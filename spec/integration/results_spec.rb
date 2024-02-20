# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'results' do
  path '/api/v1/lab/tests/{test_id}/results' do
    post 'Add results to order' do
      tags 'Results'
      description 'Attach results to specimens on order'

      consumes 'application/json'
      consumes 'application/json'

      parameter name: :test_id, in: :path, type: :integer

      parameter name: :result, in: :body, schema: {
        type: :object,
        properties: {
          encounter_id: { type: :integer },
          provider_id: { type: :integer },
          date: { type: :string },
          measures: {
            type: :array,
            items: {
              type: :object,
              properties: {
                indicator: {
                  type: :object,
                  properties: {
                    concept_id: {
                      type: :integer,
                      description: 'Concept ID of a test result indicator for this test (see GET /test_result_indicators)'
                    },
                    required: %i[concept_id]
                  }
                },
                value: { type: :string, example: 'LDL' },
                value_modifier: { type: :string, example: '=' },
                value_type: {
                  type: :string,
                  enum: %w[text boolean numeric coded],
                  description: 'Determines under what column the value is to be saved under in the obs table (defaults to text)',
                  example: 'text'
                }
              },
              required: %i[indicator value]
            }
          }
        },
        required: %i[measures]
      }

      security [api_key: []]

      let(:test) { create(:concept_name) }
      let(:indicator) { create(:concept_name) }
      let(:patient) { create(:patient) }

      before(:each) do
        lab_test_type = create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME)
        specimen_type_concept = create(:concept_name, name: Lab::Metadata::SPECIMEN_TYPE_CONCEPT_NAME)
        test_type_concept = create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
        indicator_concept = create(:concept_name, name: Lab::Metadata::TEST_RESULT_INDICATOR_CONCEPT_NAME)

        create_concept_set(test_type_concept, [test])
        create_concept_set(test, [indicator])
        create_concept_set(indicator_concept, [indicator])

        create(:concept_name, name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME)

        encounter = create(:encounter, patient:,
                                       type: create(:encounter_type, name: Lab::Metadata::ENCOUNTER_TYPE_NAME))
        order = create(:order, encounter:,
                               patient:,
                               order_type: lab_test_type,
                               concept_id: specimen_type_concept.concept_id,
                               start_date: Date.today)
        @test = create(:observation, encounter:,
                                     person_id: patient.patient_id,
                                     concept_id: test_type_concept.concept_id,
                                     order:,
                                     value_coded: create(:concept_name).concept_id)
      end

      let(:test_id) { @test.obs_id }
      let(:result) do
        {
          encounter_id: create(:encounter, patient_id: @test.person_id).encounter_id,
          date: Date.today.to_s,
          measures: [
            {
              indicator: { concept_id: indicator.concept_id },
              value_modifier: '=',
              value_type: 'numeric',
              value: '1000'
            }
          ]
        }
      end

      let(:Authorization) { 'dummy-key' }

      response 201, 'Created' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            date: { type: :string, format: :datetime },
            indicator: {
              type: :object,
              properties: {
                concept_id: { type: :integer },
                name: { type: :string, example: 'CD4 Count' }
              },
              required: %i[concept_id name]
            },
            value: {
              oneOf: [
                { type: :string, example: 'LDL' },
                { type: :number, example: 500 }
              ]
            },
            value_modifier: { type: :string, example: '=' },
            value_type: { type: :string, enum: %w[numeric text coded boolean] }
          },
          required: %i[id date indicator value value_modifier value_type]
        }

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response.size).to eq(1)
          expect(response[0]['id']).not_to be_nil
          expect(response[0]['date'].to_date).to eq(result[:date]&.to_date)
          expect(response[0]['indicator']['concept_id']).to eq(result[:measures][0][:indicator][:concept_id])
          expect(response[0]['value'].to_i).to eq(result[:measures][0][:value].to_i)
          expect(response[0]['value_type']).to eq(result[:measures][0][:value_type])
          expect(response[0]['value_modifier']).to eq(result[:measures][0][:value_modifier])
        end
      end
    end
  end
end
