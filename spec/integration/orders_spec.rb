# frozen_string_literal: true

require 'swagger_helper'

def order_schema
  {
    type: :object,
    properties: {
      id: { type: :integer },
      patient_id: { type: :integer },
      encounter_id: { type: :integer },
      order_date: { type: :string, format: :datetime },
      accession_number: { type: :string },
      specimen: {
        type: :object,
        properties: {
          concept_id: { type: :integer },
          name: { type: :string }
        },
        required: %i[concept_id name]
      },
      requesting_clinician: { type: :string, nullable: true },
      target_lab: { type: :string },
      reason_for_test: {
        type: :object,
        properties: {
          concept_id: { type: :integer },
          name: { type: :string }
        },
        required: %i[concept_id name]
      },
      tests: {
        type: :array,
        items: {
          type: :object,
          properties: {
            id: { type: :integer },
            concept_id: { type: :integer },
            name: { type: :string },
            result: {
              type: :object,
              nullable: true,
              properties: {
                id: { type: :integer },
                value: { type: :string, nullable: true },
                date: { type: :string, format: :datetime, nullable: true }
              },
              required: %i[id value date]
            }
          },
          required: %i[id concept_id name]
        }
      }
    },
    required: %i[id specimen reason_for_test accession_number patient_id order_date]
  }
end

describe 'orders' do
  before(:each) do
    @site_prefix = create(:global_property, property: 'site_prefix')
    @encounter_type = create(:encounter_type, name: Lab::Metadata::ENCOUNTER_TYPE_NAME)
    @order_type = create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME)
    @test_type = create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME).concept
    @reason_for_test = create(:concept_name, name: Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME).concept
    @requesting_clinician = create(:concept_name, name: Lab::Metadata::REQUESTING_CLINICIAN_CONCEPT_NAME).concept
    @target_lab = create(:concept_name, name: Lab::Metadata::TARGET_LAB_CONCEPT_NAME).concept
  end

  path '/api/v1/lab/orders' do
    post 'Create order' do
      tags 'Orders'

      description <<~DESC
        Create a lab order for a test.

        Broadly a lab order consists of a test type and a number of specimens.
        To each specimen is assigned a tracking number which can be used
        to query the status and results of the specimen.
      DESC

      consumes 'application/json'
      produces 'application/json'

      parameter name: :orders, in: :body, schema: {
        type: :object,
        properties: {
          orders: {
            type: :array,
            items: {
              properties: {
                encounter_id: { type: :integer },
                specimen: {
                  type: :object,
                  properties: {
                    concept_id: {
                      type: :integer,
                      description: 'Specimen type concept ID (see GET /lab/test_types)'
                    }
                  }
                },
                tests: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      concept_id: {
                        type: :integer,
                        description: 'Test type concept ID (see GET /lab/test_types)'
                      }
                    }
                  }
                },
                requesting_clinician: {
                  type: :string,
                  description: 'Fullname of the clinician requesting the test (defaults to orderer)'
                },
                target_lab: { type: :string },
                reason_for_test_id: {
                  type: :string,
                  description: 'One of routine, targeted, or confirmatory'
                }
              },
              required: %i[encounter_id tests target_lab reason_for_test_id]
            }
          }
        }
      }

      security [api_key: []]

      let(:Authorization) { 'dummy-key' }
      let(:orders) do
        {
          orders: [
            {
              encounter_id: create(:encounter, type: @encounter_type).encounter_id,
              specimen: { concept_id: create(:concept_name, name: 'Blood').concept_id },
              tests: [{ concept_id: create(:concept_name, name: 'Viral load').concept_id }],
              requesting_clinician: 'Barry Allen',
              target_lab: 'Starlabs',
              reason_for_test_id: create(:concept_name, name: 'Routine').concept_id
            }
          ]
        }
      end

      response 201, 'Created' do
        schema type: :array, items: order_schema

        run_test! do |response|
          response = JSON.parse(response.body)
          order = orders[:orders].first

          expect(response[0]['specimen']['concept_id']).to eq(order[:specimen][:concept_id])
          expect(response[0]['requesting_clinician']).to eq(order[:requesting_clinician])
          expect(response[0]['target_lab']).to eq(order[:target_lab])
          expect(response[0]['reason_for_test']['concept_id']).to eq(order[:reason_for_test_id])
          expect(Set.new(response[0]['tests'].map { |test| test['concept_id'] }))
            .to eq(Set.new(order[:tests].map { |test| test[:concept_id] }))
        end
      end
    end

    get 'Retrieve lab orders' do
      tags 'Orders'
      description 'Search/retrieve for lab orders.'

      produces 'application/json'

      security [api_key: []]

      parameter name: :patient_id,
                in: :query,
                required: false,
                type: :integer,
                description: 'Filter orders using patient_id'

      parameter name: :accession_number,
                in: :query,
                required: false,
                type: :integer,
                description: 'Filter orders using sample accession number'

      parameter name: :date,
                in: :query,
                required: false,
                type: :date,
                description: 'Select results falling on a specific date'

      parameter name: :status,
                in: :query,
                required: false,
                type: :string,
                description: 'Filter by sample status: ordered, drawn'

      parameter name: :end_date,
                in: :query,
                required: false,
                type: :date,
                description: 'Select all results before this date'

      def create_order(no_specimen: false)
        encounter = create(:encounter, type: @encounter_type)
        order = create(:order, encounter:,
                               patient_id: encounter.patient_id,
                               order_type: @order_type,
                               start_date: Date.today,
                               concept: create(:concept_name).concept,
                               accession_number: SecureRandom.alphanumeric(5))

        return if no_specimen

        observations = [
          [@test_type, { value_coded: create(:concept_name).concept_id }],
          [@target_lab, { value_text: 'Ze Lab' }],
          [@reason_for_test, { value_coded: create(:concept_name).concept_id }],
          [@requesting_clinician, { value_text: Faker::Name.name }]
        ]

        observations.each do |concept, params,|
          create(:observation, encounter:,
                               concept:,
                               person_id: encounter.patient_id,
                               order:,
                               obs_datetime: Time.now,
                               **params)
        end

        order
      end

      before(:each) do
        @orders = 5.times.map { |i| create_order(no_specimen: i.odd?) }
        create(:concept_name, name: 'Unknown')
      end

      let(:Authorization) { 'dummy' }
      let(:patient_id) { @orders.first.patient_id }
      let(:accession_number) { @orders.first.accession_number }
      let(:date) { @orders.first.start_date }
      let(:status) { 'drawn' }

      response 200, 'Success' do
        schema type: :array, items: order_schema

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response.size).to eq(1)
          expect(response[0]['patient_id']).to eq(patient_id)
          expect(response[0]['order_date'].to_date).to eq(date)
          expect(response[0]['accession_number']).to eq(accession_number)
        end
      end
    end
  end

  path '/api/v1/lab/orders/{order_id}' do
    put 'Update order' do
      tags 'Orders'

      description 'Update an existing order'

      consumes 'application/json'
      produces 'application/json'

      security [api_key: []]

      parameter name: :order_id, in: :path, type: :integer, required: true

      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          specimen: {
            type: :object,
            properties: {
              concept_id: { type: :integer }
            },
            required: [:concept_id]
          }
        }
      }

      let(:Authorization) { 'some-key' }

      let(:order_id) do
        encounter = create(:encounter)
        create(:order, order_type: create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME),
                       concept_id: create(:concept_name, name: 'Unknown').concept_id,
                       encounter:,
                       patient: encounter.patient)
          .order_id
      end

      let(:order) do
        {
          specimen: {
            concept_id: create(:concept_name).concept_id
          }
        }
      end

      response 200, 'Ok' do
        schema type: :object, properties: order_schema

        run_test!
      end
    end

    delete 'Void lab order' do
      tags 'Orders'

      description <<~DESC
        Void a lab order and all it's associated records

        This action voids an order, all it's linked tests and results.
      DESC

      security [api_key: []]

      parameter name: :order_id, in: :path, type: :integer, required: true
      parameter name: :reason, in: :query, type: :string, required: true

      let(:Authorization) { 'Bearer API Key' }

      let(:order_id) do
        encounter = create(:encounter)
        create(:order, order_type: create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME),
                       encounter:,
                       patient: encounter.patient)
          .order_id
      end

      let(:reason) { 'Hate this order!' }

      response 204, 'No Content' do
        run_test! do
          expect(Lab::LabOrder.find_by_order_id(order_id)).to be_nil
        end
      end
    end
  end

  path '/api/v1/lab/accession_number' do
    get 'Verify accession number' do
      tags 'Orders'
      description 'Verify if an accession number is valid and exists'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :accession_number, in: :query, type: :string, required: true
      security [api_key: []]

      let(:Authorization) { 'dummy' }
      let(:accession_number) { '12345' }

      response 200, 'Success' do
        schema type: :object, properties: {
          exists: { type: :boolean }
        }

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response['exists']).to be false
        end
      end
    end
  end
end
