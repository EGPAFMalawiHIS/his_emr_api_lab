# frozen_string_literal: true

require 'rails_helper'

module Lab
  RSpec.describe ConceptsService do
    subject { ConceptsService }

    let(:test_type) { create :concept_name, name: Lab::LabOrder::TEST_TYPE_CONCEPT_NAME }
    let(:specimen_type) { create :concept_name, name: Lab::LabOrder::SPECIMEN_TYPE_CONCEPT_NAME }
    let(:viral_load) { create :concept_name, name: 'Viral Load' }
    let(:tb) { create :concept_name, name: 'TB tests' }
    let(:blood) { create :concept_name, name: 'Blood' }
    let(:fbc) { create :concept_name, name: 'FBC' }
    let(:sputum) { create :concept_name, name: 'Sputum' }
    let(:xray) { create :concept_name, name: 'X-Ray' }

    def serialize_test(test_type)
      { concept_id: test_type.concept_id, name: test_type.concept_id }
    end

    before :each do
      create_concept_set = lambda do |set, elements|
        elements.map do |element|
          create :concept_set, concept_set: set.concept_id,
                               concept_id: element.concept_id
        end
      end

      create_concept_set[test_type, [viral_load, tb, blood]]
      create_concept_set[specimen_type, [fbc, sputum, xray]]
      create_concept_set[viral_load, [fbc]]
      create_concept_set[tb, [sputum, xray]]
      create_concept_set[blood, [fbc]]
    end

    describe :test_types do
      it 'retrieves all test types' do
        tests = Set.new(subject.test_types.map { |test| serialize_test(test) })
        expected = Set.new([viral_load, tb, blood].map { |test| serialize_test(test) })

        expect(tests).to eq(expected)
      end

      it 'retrieves test types by name' do
        test = serialize_test(subject.test_types(name: viral_load.name).first)

        expect(test).to eq(serialize_test(viral_load))
      end

      it 'retrieves test types having a given specimen type' do
        tests = Set.new(subject.test_types(specimen_type: fbc.name)
                               .map { |test| serialize_test(test) })
        expected = Set.new([viral_load, blood].map { |test| serialize_test(test) })

        expect(tests).to eq(expected)
      end
    end

    describe :specimen_types do
      it 'retrieves all specimen types' do
        specimens = Set.new(subject.specimen_types.map { |specimen| serialize_test(specimen) })
        expected = Set.new([fbc, sputum, xray].map { |specimen| serialize_test(specimen) })

        expect(specimens).to eq(expected)
      end

      it 'retrieves specimen types by name' do
        test = serialize_test(subject.specimen_types(name: xray.name).first)

        expect(test).to eq(serialize_test(xray))
      end

      it 'retrieves specimen types having a given test type' do
        specimens = Set.new(subject.specimen_types(test_type: tb.name)
                                   .map { |specimen| serialize_test(specimen) })
        expected = Set.new([sputum, xray].map { |specimen| serialize_test(specimen) })

        expect(specimens).to eq(expected)
      end
    end
  end
end
