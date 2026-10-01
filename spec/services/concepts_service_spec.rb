# frozen_string_literal: true

require 'rails_helper'

module Lab
  RSpec.describe ConceptsService do
    subject { ConceptsService }

    let(:test_type) { create :concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME }
    let(:specimen_type) { create :concept_name, name: Lab::Metadata::SPECIMEN_TYPE_CONCEPT_NAME }
    let(:viral_load) { add_catalogue_attributes(create(:concept_name, name: 'Viral Load')) }
    let(:tb) { add_catalogue_attributes(create(:concept_name, name: 'TB tests')) }
    let(:blood) { add_catalogue_attributes(create(:concept_name, name: 'Blood')) }
    let(:fbc) { add_catalogue_attributes(create(:concept_name, name: 'FBC')) }
    let(:sputum) { add_catalogue_attributes(create(:concept_name, name: 'Sputum')) }
    let(:xray) { add_catalogue_attributes(create(:concept_name, name: 'X-Ray')) }

    # The service returns rows read from the test catalogue attributes.
    def serialize_row(row)
      { concept_id: row['concept_id'], name: row['name'] }
    end

    def serialize_concept(concept_name)
      { concept_id: concept_name.concept_id, name: concept_name.name }
    end

    before :each do
      create_concept_set(test_type, [viral_load, tb, blood])
      create_concept_set(specimen_type, [fbc, sputum, xray])
      create_concept_set(viral_load, [fbc])
      create_concept_set(tb, [sputum, xray])
      create_concept_set(blood, [fbc])
    end

    describe :test_types do
      it 'retrieves all test types' do
        tests = Set.new(subject.test_types.map { |test| serialize_row(test) })
        expected = Set.new([viral_load, tb, blood].map { |test| serialize_concept(test) })

        expect(tests).to eq(expected)
      end

      it 'retrieves test types by name' do
        test = serialize_row(subject.test_types(name: viral_load.name).first)

        expect(test).to eq(serialize_concept(viral_load))
      end

      it 'retrieves test types having a given specimen type' do
        tests = Set.new(subject.test_types(specimen_type: fbc.name)
                               .map { |test| serialize_row(test) })
        expected = Set.new([viral_load, blood].map { |test| serialize_concept(test) })

        expect(tests).to eq(expected)
      end
    end

    describe :specimen_types do
      it 'retrieves all specimen types' do
        specimens = Set.new(subject.specimen_types.map { |specimen| serialize_row(specimen) })
        expected = Set.new([fbc, sputum, xray].map { |specimen| serialize_concept(specimen) })

        expect(specimens).to eq(expected)
      end

      it 'retrieves specimen types by name' do
        test = serialize_row(subject.specimen_types(name: xray.name).first)

        expect(test).to eq(serialize_concept(xray))
      end

      it 'retrieves specimen types having a given test type' do
        specimens = Set.new(subject.specimen_types(test_type: tb.name)
                                   .map { |specimen| serialize_row(specimen) })
        expected = Set.new([sputum, xray].map { |specimen| serialize_concept(specimen) })

        expect(specimens).to eq(expected)
      end
    end

    describe :test_result_indicators do
      let(:indicators) { create_list(:concept_name, 5).map { |indicator| add_catalogue_attributes(indicator) } }
      let(:result_indicator_concept) do
        create(:concept_name, name: Lab::Metadata::TEST_RESULT_INDICATOR_CONCEPT_NAME)
      end

      before { create_concept_set(result_indicator_concept, indicators) }

      it 'retrieves test indicators for a given test_type' do
        create_concept_set(viral_load, indicators)

        found_indicators = subject.test_result_indicators(viral_load.concept_id).map { |row| row['concept_id'] }

        expect(Set.new(found_indicators)).to eq(Set.new(indicators.collect(&:concept_id)))
      end

      it 'does not return indicators for a concept_id not marked as a test' do
        test = create(:concept_name)
        create_concept_set(test, indicators)

        found_indicators = subject.test_result_indicators(test.concept_id).to_a

        expect(found_indicators).to be_empty
      end
    end
  end
end
