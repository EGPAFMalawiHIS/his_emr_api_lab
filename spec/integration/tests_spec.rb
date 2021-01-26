# frozen_string_literal: true

require 'swagger_helper'

def test_schema
  {
    id: { type: :integer },
    concept_id: { type: :integer },
    name: { type: :string },
    order: {
      order_id: { type: :string },
      accession_number: { type: :string }
    }
  }
end

RSpec.describe 'Tests' do
  before(:each) do
    @test_type_concept = create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
    @encounter = create(:encounter)
    @order = create(:order, order_type: create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME),
                            concept: create(:concept_name).concept,
                            encounter: @encounter,
                            patient_id: @encounter.patient_id,
                            accession_number: '123456')
    @test_type = create(:concept_name)
  end

  path '/api/v1/lab/tests' do
    get 'Search for tests' do
      tags 'Tests'

      description <<~DESC
        Search for tests by accession number, date and other parameters.
      DESC

      produces 'application/json'

      parameter name: :accession_number, in: :query, type: :string, required: false
      parameter name: :test_type_id, in: :query, type: :integer, required: false
      parameter name: :specimen_type_id, in: :query, type: :integer, required: false
      parameter name: :patient_id, in: :query, type: :integer, required: false
      parameter name: :order_date, in: :query, type: :boolean, required: false

      let(:patient_id) { @order.patient_id }
      let(:accession_number) { @order.accession_number }

      # NOTE: For proper testing of this search functionality, please
      # see /spec/services/tests_service_spec.
      response 200, 'Okay' do
        schema type: :array, items: {
          type: :object,
          properties: test_schema
        }

        before(:each) do
          @test = create(:observation, concept_id: @test_type_concept.concept_id,
                                       value_coded: create(:concept_name).concept_id,
                                       order: @order,
                                       person_id: @order.patient_id,
                                       encounter_id: @order.encounter_id)
        end

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response.size).to eq(1)
          expect(response[0]['id']).to eq(@test.obs_id)
        end
      end
    end

    post 'Add tests to an existing order' do
      tags 'Tests'

      description <<~DESC
        Add tests to an existing order.

        An order can be created without specifying tests.
        This endpoint allows one to add tests to that order.
      DESC

      consumes 'application/json'
      produces 'application/json'

      parameter name: :tests, in: :body, schema: {
        type: :object,
        properties: {
          order_id: { type: :integer },
          tests: {
            type: :array,
            items: {
              type: :object,
              properties: {
                concept_id: {
                  type: :integer,
                  description: 'Test type concept ID'
                }
              },
              required: %i[concept_id]
            }
          }
        },
        required: %i[order_id tests]
      }

      security [api_key: []]

      let(:tests) do
        {
          order_id: @order.order_id,
          tests: [{ concept_id: @test_type.concept_id }]
        }
      end

      let(:Authorization) { 'dummy-key' }

      response 201, 'Created' do
        schema type: :array, items: {
          type: :object,
          properties: test_schema
        }

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response[0]['concept_id']).to eq(@test_type.concept_id)
          expect(response[0]['name']).to eq(@test_type.name)
          expect(response[0]['order']['id']).to eq(@order.order_id)
          expect(response[0]['order']['accession_number']).to eq(@order.accession_number)

          observation_exists = Observation.where(obs_id: response[0]['id'],
                                                 concept_id: @test_type_concept.concept_id,
                                                 order_id: @order.order_id,
                                                 value_coded: @test_type.concept_id)
                                          .exists?

          expect(observation_exists).to be(true)
        end
      end
    end
  end
end
