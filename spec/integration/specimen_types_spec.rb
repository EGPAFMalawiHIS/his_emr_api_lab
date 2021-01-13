# frozen_string_literal: true

require 'swagger_helper'

describe 'Specimen types' do
  path '/api/v1/lab/specimen_types' do
    before :each do
      test_type = create :concept_name, name: Lab::LabOrder::TEST_TYPE_CONCEPT_NAME
      specimen_type = create :concept_name, name: Lab::LabOrder::SPECIMEN_TYPE_CONCEPT_NAME
      viral_load = create :concept_name, name: 'Viral Load'
      fbc = create :concept_name, name: 'FBC'

      create :concept_set, concept_set: test_type.concept_id,
                           concept_id: viral_load.concept_id
      create :concept_set, concept_set: specimen_type.concept_id,
                           concept_id: fbc.concept_id
      create :concept_set, concept_set: viral_load.concept_id,
                           concept_id: fbc.concept_id
    end

    get 'Specimen types' do
      tags 'Concepts'
      description 'Retrieve all specimen types'

      produces 'application/json'
      security [api_key: []]

      parameter name: :test_type,
                in: :query,
                type: :string,
                required: false,
                description: 'Select specimen types having this test type only'

      let(:Authorization) { 'dummy-key' }
      let(:test_type) { 'Viral load' }

      response 200, 'Success' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   concept_id: { type: :integer },
                   name: { type: :string }
                 }
               },
               required: %i[concept_id name]

        run_test! do |response|
          specimen_types = JSON.parse(response.body)

          expect(specimen_types.size).to eq(1)
          expect(specimen_types[0]['name']).to eq('FBC')
        end
      end
    end
  end
end
