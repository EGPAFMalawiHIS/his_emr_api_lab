# frozen_string_literal: true

require 'rails_helper'

require_relative 'dummy_lims_api'

RSpec.describe Lab::Lims::PushWorker do
  subject { Lab::Lims::PushWorker.new(lims_api) }

  let(:lims_api) { DummyLimsApi.new }
  let(:order) { create_order(create(:patient), add_result: true) }

  before(:each) do
    @location = create(:location, parent: create(:location))
    GlobalProperty.find_by(property: 'current_health_center_id')&.delete
    create(:global_property, property: 'current_health_center_id', property_value: @location.location_id)
    create(:concept_name, name: 'Unknown')
  end

  describe :push_order do
    it 'passes a serialised order to lims_api#create_order for new orders' do
      subject.push_order_by_id(order.order_id)

      expect(lims_api.created_order).to be_an_instance_of(Lab::Lims::OrderDto)
      expect(lims_api.created_order[:tracking_number]).to eq(order.accession_number)
      expect(lims_api.created_order[:sending_facility]).to eq(@location.name)
      expect(lims_api.created_order[:districy]).to eq(@location.parent.name) # districy[sic] for district
      # TODO: Add more checks...
    end

    it 'passes a serialised order lims_api#update_order for existing orders' do
      response = subject.push_order_by_id(order.order_id) # Initial order
      subject.push_order_by_id(order.order_id) # Updated order

      expect(lims_api.updated_order.id).to eq(response[:id])
      expect(lims_api.updated_order.order).to be_an_instance_of(Lab::Lims::OrderDto)
      expect(lims_api.updated_order.order[:tracking_number]).to eq(order.accession_number)
      expect(lims_api.updated_order.order[:sending_facility]).to eq(@location.name)
      expect(lims_api.updated_order.order[:districy]).to eq(@location.parent.name) # districy[sic] for district
      # TODO: Add more checks...
    end
  end
end
