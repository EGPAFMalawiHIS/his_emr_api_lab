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
  encounter = create(:encounter, patient: patient)

  order = create(:order, order_type: create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME),
                         encounter: encounter,
                         patient: patient,
                         start_date: Date.today + seq.days,
                         accession_number: SecureRandom.uuid)
  test = create(:observation, order: order,
                              encounter: encounter,
                              person_id: patient.patient_id,
                              concept_id: create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME).concept_id,
                              value_coded: create(:concept_name).concept_id)

  create(:observation, order: order,
                       encounter: encounter,
                       person_id: patient.patient_id,
                       concept_id: create(:concept_name, name: Lab::Metadata::TARGET_LAB_CONCEPT_NAME).concept_id,
                       value_text: Faker::Address.city)

  create(:observation, order: order,
                       encounter: encounter,
                       person_id: patient.patient_id,
                       concept_id: create(:concept_name, name: Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME).concept_id,
                       value_coded: create(:concept_name, name: 'Routine').concept_id)

  return order unless add_result

  create(:observation, order: order,
                       encounter: create(:encounter, patient: patient),
                       concept_id: create(:concept_name, name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME).concept_id,
                       person_id: patient.patient_id,
                       obs_group_id: test.obs_id,
                       value_modifier: '=',
                       value_text: '200')

  order
end
