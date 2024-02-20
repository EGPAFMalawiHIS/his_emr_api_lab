# frozen_string_literal: true

##
# Helpers for generating various test fixtures
#

def create_concept_set(set, elements)
  elements.map do |element|
    create :concept_set, concept_set: set.concept_id,
                         concept_id: element.concept_id
  end
end

def create_order(patient, seq: 0, add_result: false)
  encounter = create(:encounter, patient:)

  order = create(:order, order_type: create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME),
                         concept_id: create(:concept_name).concept_id,
                         encounter:,
                         patient:,
                         start_date: Date.today + seq.days,
                         accession_number: SecureRandom.uuid)
  test = create(:observation, order:,
                              encounter:,
                              person_id: patient.patient_id,
                              concept_id: create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME).concept_id,
                              value_coded: create(:concept_name).concept_id)

  create(:observation, order:,
                       encounter:,
                       person_id: patient.patient_id,
                       concept_id: create(:concept_name, name: Lab::Metadata::TARGET_LAB_CONCEPT_NAME).concept_id,
                       value_text: Faker::Address.city)

  create(:observation, order:,
                       encounter:,
                       person_id: patient.patient_id,
                       concept_id: create(:concept_name, name: Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME).concept_id,
                       value_coded: create(:concept_name, name: 'Routine').concept_id)

  return order unless add_result

  result = create(:observation, order:,
                                encounter: create(:encounter, patient:),
                                concept_id: create(:concept_name, name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME).concept_id,
                                person_id: patient.patient_id,
                                obs_group_id: test.obs_id,
                                value_modifier: '=',
                                value_text: '200')

  5.times.each do
    create(:observation, obs_group_id: result.obs_id,
                         concept_id: create(:concept_name).concept_id,
                         person_id: result.person_id,
                         encounter_id: result.encounter_id,
                         value_modifier: '=',
                         value_numeric: 200)
  end

  order
end
