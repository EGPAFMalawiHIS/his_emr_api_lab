require 'rails_helper'

module Lab
  RSpec.describe LimsOrderMapping, type: :model do
    subject { create(:lims_order_mapping, order: order) }

    let(:patient) { create(:patient) }
    let(:order) { create(:lab_order, patient: patient, encounter: create(:encounter, patient: patient)) }

    describe 'associations' do
      it { should belong_to(:order).class_name('Lab::LabOrder') }
    end

    describe 'validations' do
      it { should validate_uniqueness_of(:order_id) }
      it { should validate_presence_of(:order_id) }

      it { should validate_uniqueness_of(:lims_id) }
      it { should validate_presence_of(:lims_id) }
    end
  end
end
