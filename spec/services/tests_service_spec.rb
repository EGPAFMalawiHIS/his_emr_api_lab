# frozen_string_literal: true

require 'rails_helper'

module Lab
  RSpec.describe TestsService do
    subject { TestsService }

    describe :find_tests do
      before :all do
        @test_type_concept = create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
        @test_result_concept = create(:concept_name, name: Lab::Metadata::LAB_TEST_RESULT_CONCEPT_NAME)
        @lab_order_type = create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME)

        def create_order(patient, seq, add_result:)
          encounter = create(:encounter, patient: patient)

          order = create(:order, order_type: @lab_order_type,
                                 encounter: encounter,
                                 patient: patient,
                                 start_date: Date.today + seq.days,
                                 accession_number: SecureRandom.uuid)
          test = create(:observation, order: order,
                                      encounter: encounter,
                                      person_id: patient.patient_id,
                                      concept_id: @test_type_concept.concept_id,
                                      value_coded: create(:concept_name).concept_id)

          return order unless add_result

          create(:observation, order: order,
                               encounter: create(:encounter, patient: patient),
                               concept_id: @test_result_concept.concept_id,
                               person_id: patient.patient_id,
                               obs_group_id: test.obs_id,
                               value_modifier: '=',
                               value_text: '200')

          order
        end

        5.times.each { |i| create_order(create(:patient), i, add_result: false) } # Control group

        @patient = create(:patient)
        @orders = 5.times.collect { |i| create_order(@patient, i, add_result: i.even?) }
      end

      it 'retrieves tests by test_type_id' do
        test_obs = @orders.first
                          .observations
                          .where(concept_id: @test_type_concept.concept_id)
                          .first

        tests_found = subject.find_tests(test_type_id: test_obs.value_coded)

        expect(tests_found.size).to eq(1)
        expect(tests_found.first[:id]).to eq(test_obs.obs_id)
        expect(tests_found.first[:order][:id]).to eq(test_obs.order_id)
      end

      it 'retrieves tests by patient_id' do
        tests_found = subject.find_tests(patient_id: @patient.patient_id)
                             .map { |test| test[:order][:id] }
                             .uniq
                             .sort

        expect(tests_found).to eq(@orders.collect(&:order_id).uniq.sort)
      end

      it 'retrieves tests by accession number' do
        accession_number = @orders.last.accession_number
        tests_found = subject.find_tests(accession_number: accession_number)

        expect(tests_found.size).to eq(1)
        expect(tests_found.first[:order][:id]).to eq(@orders.last.order_id)
      end

      it 'retrieves tests by order date' do
        date = @orders.last.start_date.to_date
        tests_found = subject.find_tests(order_date: date)

        expect(tests_found.size).to eq(2)

        tests_found.each do |test|
          found_date = Lab::LabOrder.find(test[:order][:id]).start_date.to_date
          expect(found_date).to eq(date)
        end
      end

      it 'retrieves tests by specimen type id' do
        specimen_type_id = @orders.first.concept_id
        tests_found = subject.find_tests(specimen_type_id: specimen_type_id)

        expect(tests_found.size).to eq(1)
        expect(tests_found.first[:order][:id]).to eq(@orders.first.order_id)
      end

      it 'retrieves tests without results' do
        tests_found = subject.find_tests(pending_results: 'true')

        expect(tests_found.size).to eq(7) # 2 from @patient and rest from control group

        tests_found.each do |test|
          expect(test[:result]).to be_nil
        end
      end

      it 'retrieves all tests if no filters are specified' do
        tests_found = subject.find_tests({})

        expect(tests_found.size).to eq(10)
      end
    end
  end
end
