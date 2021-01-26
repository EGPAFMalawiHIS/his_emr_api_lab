# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lab::AccessionNumberService' do
  subject { Lab::AccessionNumberService }

  describe '#next_accession_number' do
    context 'with site_prefix set' do
      before :each do
        @site_prefix = create(:global_property, property: 'site_prefix', property_value: 'LLH')
      end

      it 'returns a combination of site_prefix, a transformed date, and a counter' do
        date = 5.days.ago
        accession_number = subject.next_accession_number(date)
        expected_accession_number = subject.send(:format_accession_number, date, 1)

        expect(accession_number).to eq(expected_accession_number)
        expect(accession_number).to start_with("X#{@site_prefix.property_value}")
        expect(accession_number).to end_with('1')
      end

      it "uses today's date if date is not specified" do
        accession_number = subject.next_accession_number
        expected_accession_number = subject.send(:format_accession_number, Date.today, 1)

        expect(accession_number).to eq(expected_accession_number)
      end
    end

    context 'without site_prefix set' do
      it 'raises runtime error if site_prefix is not set' do
        expect { subject.next_accession_number }
          .to raise_exception(RuntimeError, /'site_prefix' not set/i)
      end
    end
  end
end
