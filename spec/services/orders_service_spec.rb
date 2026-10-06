# frozen_string_literal: true

require 'rails_helper'

module Lab
  RSpec.describe OrdersService do
    subject { OrdersService }

    before :each do
      # Initialize Lab metadata...
      @site_prefix = create(:global_property, property: 'site_prefix')
      @encounter_type = create(:encounter_type, name: Lab::Metadata::ENCOUNTER_TYPE_NAME)
      @order_type = create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME)

      ['Unknown',
       Lab::Metadata::TEST_TYPE_CONCEPT_NAME,
       Lab::Metadata::REQUESTING_CLINICIAN_CONCEPT_NAME,
       Lab::Metadata::TARGET_LAB_CONCEPT_NAME,
       Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME,
       Lab::Metadata::COMMENT_TO_FULFILLER_CONCEPT_NAME,
       Lab::Metadata::TEST_METHOD_CONCEPT_NAME].each do |name|
        create(:concept_name, name:)
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

        expect { subject.order_test(params_subset) }
          .to raise_error(StandardError, 'encounter_id|uuid or patient_id|uuid required')
      end

      it 'requires tests to be specified' do
        params_subset = params.delete_if { |key, _| key == 'tests' }

        expect { subject.order_test(params_subset) }.to raise_error(::InvalidParameterError)
      end

      it 'does not require specimen to be specified' do
        params_subset = params.delete_if { |key, _| key == 'specimen' }

        expect do
          order = subject.order_test(params_subset)
          expect(order['specimen']['concept_id']).to eq(ConceptName.find_by_name!('Unknown').concept_id)
        end.not_to raise_error
      end

      it 'attaches tests to the order' do
        order = subject.order_test(params)

        tests = Lab::LabTest.where(order_id: order[:id])
        expect(tests.size).to eq(params[:tests].size)
      end
    end

    describe :update_order do
      let(:encounter) { create(:encounter, type: @encounter_type) }
      let(:test_types) { create_list(:concept, 5) }
      let(:reason_for_test) { create(:concept_name) }

      let(:params) do
        ActiveSupport::HashWithIndifferentAccess.new(
          encounter_id: encounter.encounter_id,
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

      it 'allows updating specimen from unknown to something else' do
        order = subject.order_test(params)
        new_specimen = create(:concept_name, name: 'Blood')
        order = subject.update_order(order['id'], specimen: { concept_id: new_specimen.concept_id })

        expect(Order.find(order[:id]).concept_id).to eq(new_specimen.concept_id)
      end

      it 'does not allow updating a known specimen' do
        complete_params = params.dup
        complete_params[:specimen] = { concept_id: create(:concept_name, name: 'Blood').concept_id }

        order = subject.order_test(complete_params)

        expect { subject.update_order(order[:id], specimen: { concept_id: create(:concept_name) }) }
          .to raise_error(::UnprocessableEntityError)
      end
    end

    describe :lab_orders do
      let(:encounter) { create(:encounter, type: @encounter_type) }
      let(:test_type) { create(:concept) }

      def place_order(location_id:, start_date:)
        order = subject.order_test(
          ActiveSupport::HashWithIndifferentAccess.new(
            encounter_id: encounter.encounter_id,
            specimen: { concept_id: create(:concept_name).concept_id },
            tests: [{ concept_id: test_type.concept_id }],
            start_date:,
            requesting_clinician: 'Doctor Seuss',
            target_lab: 'Halls of Valhalla',
            reason_for_test_id: create(:concept_name).concept_id
          )
        )
        Lab::LabTest.unscoped.where(order_id: order[:id]).update_all(location_id:, date_created: start_date)
        Lab::LabOrder.unscoped.where(order_id: order[:id]).update_all(start_date:)
        order
      end

      it 'reports the last order date of the requested location only' do
        place_order(location_id: 8, start_date: 3.days.ago)
        place_order(location_id: 9, start_date: 1.day.ago)

        summary = subject.lab_orders(5.days.ago, Time.now, location_id: 8)

        expect(summary[:count]).to eq(1)
        expect(summary[:last_order_date]).to eq(3.days.ago.to_date)
      end

      it 'reports the latest order overall when no location is given' do
        place_order(location_id: 8, start_date: 3.days.ago)
        place_order(location_id: 9, start_date: 1.day.ago)

        summary = subject.lab_orders(5.days.ago, Time.now)

        expect(summary[:count]).to eq(2)
        expect(summary[:last_order_date]).to eq(Lab::LabOrder.last.start_date.to_date)
      end
    end

    describe :void_order do
      before :each do
        encounter = create(:encounter)
        @order = subject.order_test(encounter_id: encounter.encounter_id,
                                    target_lab: 'Rockport',
                                    requesting_clinician: 'Razor',
                                    specimen: { concept_id: create(:concept_name).concept_id },
                                    tests: [{ concept_id: create(:concept_name).concept_id }],
                                    reason_for_test_id: create(:concept_name).concept_id)

        create(:concept_name, name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME)
        ResultsService.create_results(
          @order[:tests][0][:id],
          encounter_id: create(:encounter).encounter_id,
          measures: [
            {
              indicator: { concept_id: create(:concept_name).concept_id },
              value: 42
            }
          ]
        )
      end

      it 'voids an order and all its associated records' do
        expect(Lab::LabOrder.where(order_id: @order[:id]).exists?).to be(true)
        expect(Observation.where(order_id: @order[:id]).exists?).to be(true)
        expect(Observation.where(obs_group_id: @order[:tests][0][:id]).exists?).to be(true)

        subject.void_order(@order[:id], 'Sent to the catacombs')

        expect(Lab::LabOrder.where(order_id: @order[:id]).exists?).to be(false)
        expect(Observation.where(order_id: @order[:id]).exists?).to be(false)
        expect(Observation.where(obs_group_id: @order[:tests][0][:id]).exists?).to be(false)
      end
    end
  end
end
