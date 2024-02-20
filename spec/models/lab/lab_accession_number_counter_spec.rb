# frozen_string_literal: true

require 'rails_helper'

module Lab
  RSpec.describe LabAccessionNumberCounter, type: :model do
    subject { LabAccessionNumberCounter }

    it 'does not allow duplicate entries on a given date' do
      expect do
        subject.create(date: Date.today, value: 1)
        subject.create(date: Date.today, value: 1)
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
