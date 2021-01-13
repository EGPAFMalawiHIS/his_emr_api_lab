# frozen_string_literal: true

require 'rails_helper'

module Lab
  RSpec.describe OrdersService do
    subject { OrdersService }

    before :each do
      # Initialize Lab metadata...
      @encounter_type = create(:encounter_type, name: LabEncounter::ENCOUNTER_TYPE_NAME)
      @order_type = create(:order_type, name: LabOrder::ORDER_TYPE_NAME)

      [LabOrder::TEST_TYPE_CONCEPT_NAME,
       LabOrder::REQUESTING_CLINICIAN_CONCEPT_NAME,
       LabOrder::TARGET_LAB_CONCEPT_NAME,
       LabOrder::REASON_FOR_TEST_CONCEPT_NAME].each do |name|
        create(:concept_name, name: name)
      end
    end

    describe :order_test do
      let(:encounter) { create(:encounter, type: @encounter_type) }
      let(:specimen_type) { create(:concept_name) }
      let(:test_types) { create_list(:concept, 5) }
      let(:reason_for_test) { create(:concept_name) }

      let(:params) do
        ActiveSupport::HashWithIndifferentAccess.new(
          encounter_id: encounter.encounter_id,
          specimen: { concept_id: specimen_type.concept_id },
          tests: test_types.map do |type|
            { concept_id: type.concept_id }
          end,
          start_date: Date.today,
          end_date: 5.days.from_now,
          requesting_clinician: 'Doctor Seuss',
          target_lab: 'Halls of Valhalla',
          reason_for_test_id: reason_for_test.concept_id
        )
      end

      it 'creates an encounter if one is not specified' do
        expect { subject.order_test(params) }.to change(Lab::LabOrder.all, :count).by(1)
      end

      it 'uses provided encounter_id to create order' do
        order = subject.order_test(params)
        expect(order['encounter_id']).to eq(params[:encounter_id])
      end

      it 'requires encounter_id, or patient_id and program_id' do
        params_subset = params.delete_if { |key, _| %w[encounter_id patient_id program_id].include?(key) }

        expect { subject.order_test(params_subset) }.to raise_error(::InvalidParameterError)
      end

      it 'attaches tests to the order' do
        order = subject.order_test(params)

        tests = Lab::LabTest.where(order_id: order[:order_id])
        expect(tests.size).to eq(params[:tests].size)
      end
    end
  end
end
