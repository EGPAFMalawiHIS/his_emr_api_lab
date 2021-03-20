# frozen_string_literal: true

require 'swagger_helper'

describe 'reasons_for_test' do
  path '/api/v1/lab/reasons_for_test' do
    get 'Reasons for test' do
      description 'Retrieve default reasons for test concept set'
      tags 'Concepts'

      security [api_key: []]
      produces 'application/json'

      let(:Authorization) { 'dummy-key' }

      before :each do
        reason_for_test = create(:concept_name, name: Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME)
        @reason = create(:concept_name)
        create_concept_set(reason_for_test, [@reason])
      end

      response 200, 'Success' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   concept_id: { type: :integer },
                   name: { type: :string, example: 'Routine' }
                 },
                 required: %i[concept_id name]
               }

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response.size).to eq(1)
          expect(response[0]).to eq({ 'concept_id' => @reason.concept_id, 'name' => @reason.name })
        end
      end
    end
  end
end
