# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Test Result Indicators' do
  path '/api/v1/lab/test_result_indicators' do
    get 'Test Result Indicators' do
      tags 'Concepts'
      description 'Retrieve all result indicators for a given test'

      produces 'application/json'
      security [api_key: []]

      parameter name: :test_type_id,
                in: :query,
                type: :integer,
                required: true,
                description: 'Concept ID for the desired test'

      let(:test) { create(:concept_name) }
      let(:indicators) { create_list(:concept_name, 5) }

      let(:test_type_id) { test.concept_id }  # See parameter above
      let(:Authorization) { 'Ndijumpheko!' }

      before :each do
        test_type_concept = create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
        result_indicator_concept = create(:concept_name, name: Lab::Metadata::TEST_RESULT_INDICATOR_CONCEPT_NAME)
        create_concept_set(test_type_concept, [test])
        create_concept_set(result_indicator_concept, indicators)
        create_concept_set(test, indicators)
      end

      response 200, 'Ok' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   concept_id: { type: :integer },
                   name: { type: :string }
                 },
                 required: %i[concept_id name]
               }

        run_test! do |response|
          response_body = JSON.parse(response.body)
          found_indicators = response_body.collect { |indicator| indicator['concept_id'] }

          expect(Set.new(found_indicators)).to eq(Set.new(indicators.collect(&:concept_id)))
        end
      end
    end
  end
end
