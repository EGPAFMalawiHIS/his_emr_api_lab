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

  describe :process_order do
    before do
      allow(worker).to receive(:find_patient_by_nhid).and_return(patient)
      allow(worker).to receive(:match_patient_demographics).and_return({})
      allow(worker).to receive(:order_saved)
    end

    it 'does not report unmapped orders as saved' do
      allow(worker).to receive(:save_order).and_return(nil)

      worker.process_order(order_dto)

      expect(worker).not_to have_received(:order_saved)
    end

    it 'reports mapped orders as saved' do
      allow(worker).to receive(:save_order).and_return({ id: 42 })

      worker.process_order(order_dto)

      expect(worker).to have_received(:order_saved).with(order_dto)
    end
  end
end
