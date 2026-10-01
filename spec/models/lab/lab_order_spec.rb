# frozen_string_literal: true

require 'rails_helper'

module Lab
  RSpec.describe LabOrder, type: :model do
    describe 'start_date validation' do
      def start_date_errors(order)
        order.valid?
        order.errors[:start_date]
      end

      it 'rejects a start date in the future' do
        order = LabOrder.new(start_date: Date.current + 30.days)

        expect(start_date_errors(order)).to include('cannot be in the future')
      end

      it 'accepts a start date of today' do
        expect(start_date_errors(LabOrder.new(start_date: Date.current))).to be_empty
      end

      it 'accepts a start date of tomorrow to cover timezone differences' do
        expect(start_date_errors(LabOrder.new(start_date: Date.current + 1.day))).to be_empty
      end

      it 'accepts a start date in the past' do
        expect(start_date_errors(LabOrder.new(start_date: Date.new(2024, 5, 1)))).to be_empty
      end

      it 'does not check orders whose start date is not changing, so they can still be voided' do
        order = LabOrder.new(start_date: Date.current + 30.days)
        order.clear_changes_information

        expect(start_date_errors(order)).to be_empty
      end
    end
  end
end
