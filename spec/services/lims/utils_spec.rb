# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lab::Lims::Utils do
  describe :parse_date do
    it 'accepts ISO dates' do
      expect(Lab::Lims::Utils.parse_date('2026-09-16')).to eq('2026-09-16')
      expect(Lab::Lims::Utils.parse_date('2026-09-16T00:00:00.000+02:00')).to eq('2026-09-16T00:00:00.000+02:00')
    end

    it 'accepts dd-mm-yyyy, yyyymmddhhmmss and dd/mm/yyyy dates' do
      expect(Lab::Lims::Utils.parse_date('16-09-2026')).to eq('2026-09-16')
      expect(Lab::Lims::Utils.parse_date('20260916000000')).to eq('2026-09-16')
      expect(Lab::Lims::Utils.parse_date('16/09/2026')).to eq('2026-09-16')
    end

    it 'does not rewrite year 00xx into 20xx' do
      expect { Lab::Lims::Utils.parse_date('0026-09-16') }.to raise_error(Lab::Lims::InvalidDate)
    end

    it 'rejects dates in the 1800s' do
      expect { Lab::Lims::Utils.parse_date('1800-09-16') }.to raise_error(Lab::Lims::InvalidDate)
    end

    it 'rejects two-digit years' do
      expect { Lab::Lims::Utils.parse_date('16-09-26') }.to raise_error(Lab::Lims::InvalidDate)
    end

    it 'rejects dates that do not exist' do
      expect { Lab::Lims::Utils.parse_date('2026-02-31') }.to raise_error(Lab::Lims::InvalidDate)
      expect { Lab::Lims::Utils.parse_date('31-02-2026') }.to raise_error(Lab::Lims::InvalidDate)
    end

    it 'rejects dates in the future' do
      expect { Lab::Lims::Utils.parse_date((Date.current + 30.days).to_s) }.to raise_error(Lab::Lims::InvalidDate)
    end

    it 'allows tomorrow to cover timezone differences' do
      tomorrow = (Date.current + 1.day).to_s

      expect(Lab::Lims::Utils.parse_date(tomorrow)).to eq(tomorrow)
    end

    it 'rejects unrecognised formats' do
      expect { Lab::Lims::Utils.parse_date('not a date') }.to raise_error(Lab::Lims::InvalidDate)
    end

    it 'raises a LimsException so the pull worker records a failed import' do
      expect { Lab::Lims::Utils.parse_date('0026-09-16') }.to raise_error(Lab::Lims::LimsException)
    end

    it 'uses the fallback date when the date is invalid' do
      expect(Lab::Lims::Utils.parse_date('0026-09-16', '2026-09-16')).to eq('2026-09-16')
    end

    it 'uses the fallback date when the date is blank' do
      expect(Lab::Lims::Utils.parse_date(nil, '2026-09-16')).to eq('2026-09-16')
    end

    it 'rejects an invalid fallback date' do
      expect { Lab::Lims::Utils.parse_date('0026-09-16', '0026-09-16') }.to raise_error(Lab::Lims::InvalidDate)
    end
  end
end
