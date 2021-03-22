# frozen_string_literal: true

require 'rails_helper'

describe Lab::ResultsService do
  subject { Lab::ResultsService }

  let(:patient) { create(:patient) }
  let(:encounter) { create(:encounter, patient: patient) }
  let(:indicator) { create(:concept_name) }
  let(:order) do
    create(:order, order_type: create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME),
                   encounter: encounter,
                   patient: patient,
                   start_date: Date.today,
                   accession_number: SecureRandom.uuid)
  end
  let(:test) do
    create(:observation, encounter: encounter,
                         person_id: patient.patient_id,
                         concept_id: create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME).concept_id,
                         value_coded: create(:concept_name).concept_id,
                         order: order)
  end

  let(:params) do
    {
      provider_id: create(:user).user_id,
      date: Date.today.to_s,
      measures: [
        indicator: {
          concept_id: indicator.concept_id
        },
        value: 500,
        value_type: 'numeric',
        value_modifier: '='
      ]
    }
  end

  let(:params_without) do
    lambda do |*keys|
      remove_child = lambda do |hash, key, *more_keys|
        hash = hash.dup

        return hash.delete_if { |current_key, _| current_key == key } if more_keys.empty?

        hash[key] = remove_child[hash[key], *more_keys]
        hash
      end

      remove_child[params, *keys]
    end
  end

  before(:each) do
    create(:encounter_type, name: Lab::Metadata::ENCOUNTER_TYPE_NAME)
    create(:concept_name, name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME)
  end

  describe :create_results do
    it 'requires measures.value' do
      expect { subject.create_results(test.obs_id, params_without[:measures, 0, :value]) }
        .to raise_error(InvalidParameterError)
    end

    it 'requires measures.indicator.concept_id' do
      expect { subject.create_results(test.obs_id, params_without[:measures, 0, :indicator, :concept_id]) }
        .to raise_error(InvalidParameterError)
    end

    it 'raises InvalidParameterError if an invalid value_type is specified' do
      params[:measures][0][:value_type] = 'None existent type'
      expect { subject.create_results(test.obs_id, params) }.to raise_error(InvalidParameterError)
    end

    it 'creates result measures with correct value_type' do
      measures = subject.create_results(test.obs_id, params)

      expect(measures.size).to eq(1)
      expect(measures[0][:id]).not_to be_nil
      expect(measures[0][:indicator][:concept_id]).to eq(indicator.concept_id)
      expect(measures[0][:value].to_i).to eq(params[:measures][0][:value].to_i)
      expect(measures[0][:value_type]).to eq(params[:measures][0][:value_type])
      expect(measures[0][:value_modifier]).to eq(params[:measures][0][:value_modifier])
    end
  end
end
