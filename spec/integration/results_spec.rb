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
          modifier: { type: :string },
          value: { type: :string },
          date: { type: :string }
        },
        required: %i[value]
      }

      security [api_key: []]

      before(:each) do
        lab_test_type = create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME)
        specimen_type_concept = create(:concept_name, name: Lab::Metadata::SPECIMEN_TYPE_CONCEPT_NAME)
        test_type_concept = create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME)

        create(:encounter_type, name: Lab::Metadata::ENCOUNTER_TYPE_NAME)
        create(:concept_name, name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME)

        encounter = create(:encounter)
        order = create(:order, encounter: encounter,
                               patient: encounter.patient,
                               order_type: lab_test_type,
                               concept_id: specimen_type_concept.concept_id,
                               start_date: Date.today)
        @test = create(:observation, encounter: encounter,
                                     person_id: encounter.patient_id,
                                     concept_id: test_type_concept.concept_id,
                                     order: order,
                                     value_coded: create(:concept_name).concept_id)
      end

      let(:test_id) { @test.obs_id }
      let(:result) do
        {
          encounter_id: create(:encounter, patient_id: @test.person_id).encounter_id,
          modifier: '=',
          value: '1000',
          date: Date.today.to_s
        }
      end

      let(:Authorization) { 'dummy-key' }

      response 201, 'Created' do
        schema type: :object, properties: {
          date: { type: :string, format: :datetime },
          value: { type: :string },
          modifier: { type: :string }
        }

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response['id']).not_to be_nil
          expect(response['date'].to_date).to eq(result[:date]&.to_date)
          expect(response['value']).to eq(result[:value])
          expect(response['modifier']).to eq(result[:modifier])
        end
      end
    end
  end
end
