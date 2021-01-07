# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'orders' do
  path '/api/v1/lab/orders/{order_id}/specimens' do
    post 'Add specimens to order' do
      tags 'Lab'

      description <<~DESC
        Add specimens to an existing order.

        An order can be created without specifying specimens.
        This endpoint allows one to add specimens to that order.
      DESC

      consumes 'application/json'
      produces 'application/json'

      parameter name: :specimens, in: :body, schema: {
        type: :object,
        properties: {
          specimens: {
            type: :array,
            items: {
              type: :object,
              properties: {
                concept_id: {
                  type: :integer,
                  description: 'Specimen type concept ID'
                }
              },
              required: %i[concept_id]
            }
          }
        },
        required: %i[specimens]
      }

      parameter name: :order_id, in: :path, type: :integer

      before(:each) do
        create(:concept_name, name: Lab::LabOrder::SPECIMEN_TYPE_CONCEPT_NAME)
      end

      let(:order_id) do
        encounter = create(:encounter)

        create(:order, order_type: create(:order_type, name: Lab::LabOrder::ORDER_TYPE_NAME),
                       concept: create(:concept_name).concept,
                       encounter: encounter,
                       patient_id: encounter.patient_id)
          .order_id
      end

      let(:specimens) do
        {
          specimens: [{ concept_id: create(:concept_name).concept_id }]
        }
      end

      response 201, 'Created' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            concept_id: { type: :integer },
            name: { type: :string }
          }
        }

        run_test! do |response|
          response = JSON.parse(response.body)

          expect(response[0]['concept_id']).to eq(specimens[:specimens][0][:concept_id])
          expect(Observation.find(response[0]['id']).order_id).to eq(order_id)
        end
      end
    end
  end
end
