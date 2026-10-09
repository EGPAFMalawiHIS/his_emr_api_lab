# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lab::Lims::PullWorker do
  subject(:worker) { Lab::Lims::PullWorker.new(nil) }

  let(:patient) { instance_double(Patient, patient_id: 1) }
  let(:order_dto) do
    Lab::Lims::OrderDto.new(
      _id: 'XMPC194G30019',
      tracking_number: 'XMPC194G30019',
      patient: { id: 'P170000000001' },
      tests: ['HIV viral load'],
      test_results: {}
    )
  end

  describe :save_order do
    before do
      allow(worker).to receive(:death_date_before_order).and_return(nil)
    end

    context 'when the order is dated after the patient died' do
      before do
        order_dto[:date_created] = '2026-09-16'
        allow(worker).to receive(:death_date_before_order).and_return(Date.new(2024, 5, 1))
        allow(worker).to receive(:find_order_mapping_by_lims_id)
        allow(worker).to receive(:update_order)
        allow(Lab::LimsFailedImport).to receive(:find_or_create_by!)
      end

      it 'does not update the order' do
        expect(worker.send(:save_order, patient, order_dto)).to be_nil

        expect(worker).not_to have_received(:update_order)
        expect(worker).not_to have_received(:find_order_mapping_by_lims_id)
      end

      it 'records the order once for review' do
        worker.send(:save_order, patient, order_dto)

        expect(Lab::LimsFailedImport).to have_received(:find_or_create_by!).with(
          lims_id: 'XMPC194G30019',
          tracking_number: 'XMPC194G30019',
          reason: Lab::Lims::PullWorker::DECEASED_PATIENT_REASON
        )
      end
    end

    context 'when the LIMS order has no local mapping' do
      before do
        allow(worker).to receive(:find_order_mapping_by_lims_id).with('XMPC194G30019').and_return(nil)
        allow(Lab::LimsFailedImport).to receive(:find_or_create_by!)
      end

      it 'does not create an order or a mapping' do
        expect(Lab::OrdersService).not_to receive(:order_test)
        expect(Lab::LimsOrderMapping).not_to receive(:create)

        expect(worker.send(:save_order, patient, order_dto)).to be_nil
      end

      it 'records the unmapped order once for review' do
        worker.send(:save_order, patient, order_dto)

        expect(Lab::LimsFailedImport).to have_received(:find_or_create_by!).with(
          lims_id: 'XMPC194G30019',
          tracking_number: 'XMPC194G30019',
          reason: Lab::Lims::PullWorker::UNMAPPED_ORDER_REASON
        )
      end
    end

    context 'when the LIMS order is mapped to a local order' do
      let(:mapping) { instance_double(Lab::LimsOrderMapping, order_id: 42, update: true) }

      before do
        allow(worker).to receive(:find_order_mapping_by_lims_id).with('XMPC194G30019').and_return(mapping)
        allow(worker).to receive(:update_order).and_return({ id: 42 })
      end

      it 'updates the mapped order' do
        expect(worker.send(:save_order, patient, order_dto)).to eq({ id: 42 })

        expect(worker).to have_received(:update_order).with(patient, 42, order_dto)
        expect(mapping).to have_received(:update).with(pulled_at: kind_of(Time))
      end
    end

    context 'when the LIMS order has no tracking number' do
      it 'raises MissingAccessionNumber' do
        order_dto[:tracking_number] = nil

        expect { worker.send(:save_order, patient, order_dto) }
          .to raise_error(Lab::Lims::MissingAccessionNumber)
      end
    end
  end

  describe :death_date_before_order do
    let(:death_date) { Date.new(2024, 5, 1) }

    def check(dead:, death_date:, order_date:)
      allow(Person).to receive_message_chain(:unscoped, :find_by).with(person_id: 1)
                                                                  .and_return(double(dead:, death_date:))
      order_dto[:date_created] = order_date

      worker.send(:death_date_before_order, patient, order_dto)
    end

    it 'returns the death date when the order is dated after death' do
      expect(check(dead: true, death_date:, order_date: '2024-05-02')).to eq(death_date)
    end

    it 'allows orders dated on the day of death' do
      expect(check(dead: true, death_date:, order_date: '2024-05-01')).to be_nil
    end

    it 'allows orders dated before death so their results still arrive' do
      expect(check(dead: true, death_date:, order_date: '2024-04-30')).to be_nil
    end

    it 'allows orders for patients who are alive' do
      expect(check(dead: false, death_date: nil, order_date: '2024-05-02')).to be_nil
    end

    it 'treats a dead flag stored as 0 as alive' do
      expect(check(dead: 0, death_date:, order_date: '2024-05-02')).to be_nil
    end

    it 'allows orders when the death date is not recorded' do
      expect(check(dead: true, death_date: nil, order_date: '2024-05-02')).to be_nil
    end
  end

  describe :update_order do
    let(:unknown_specimen_id) { 1067 }
    let(:lims_specimen_id) { 11_914 }
    let(:local_order) { instance_double(Lab::LabOrder, concept_id: local_specimen_id) }
    let(:sent_params) { [] }

    before do
      order_dto[:test_results] = {}
      allow(order_dto).to receive(:to_order_service_params).and_return(
        ActiveSupport::HashWithIndifferentAccess.new(specimen: { concept_id: lims_specimen_id }, location_id: 1)
      )
      allow(Lab::LabOrder).to receive_message_chain(:unscoped, :find).with(42).and_return(local_order)
      allow(worker).to receive(:unknown_specimen_concept_id).and_return(unknown_specimen_id)
      allow(worker).to receive(:order_has_results?).with(42).and_return(has_results)
      allow(worker).to receive(:save_status_trails_from_nlims)
      allow(Lab::OrdersService).to receive(:update_order) { |_id, params| sent_params << params }
    end

    def sent_specimen_id
      worker.send(:update_order, patient, 42, order_dto)

      sent_params.last.dig(:specimen, :concept_id)
    end

    context 'when the sample has not been drawn and there are no results' do
      let(:local_specimen_id) { unknown_specimen_id }
      let(:has_results) { false }

      it 'sets the specimen from LIMS' do
        expect(sent_specimen_id).to eq(lims_specimen_id)
      end
    end

    context 'when the sample has already been drawn' do
      let(:local_specimen_id) { 500 }
      let(:has_results) { false }

      it 'keeps the local specimen' do
        expect(sent_specimen_id).to eq(500)
      end
    end

    context 'when the order already has results' do
      let(:local_specimen_id) { unknown_specimen_id }
      let(:has_results) { true }

      it 'keeps the local specimen' do
        expect(sent_specimen_id).to eq(unknown_specimen_id)
      end
    end
  end

  describe :process_order do
    before do
      allow(worker).to receive(:find_patient_by_nhid).and_return(patient)
      allow(worker).to receive(:match_patient_demographics).and_return({})
      allow(worker).to receive(:order_saved)
    end

    it 'reports mapped orders as saved' do
      allow(worker).to receive(:save_order).and_return({ id: 42 })

      worker.process_order(order_dto)

      expect(worker).to have_received(:order_saved).with(order_dto)
    end
  end
end
