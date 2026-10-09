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

##
# Gives a concept the 'TEST CATALOGUE NAME' and 'NLIMS CODE' attributes that
# the lab services read test, specimen and measure names and codes from.
def add_catalogue_attributes(concept_name, nlims_code: "NLIMS_SPEC_#{concept_name.concept_id}")
  { 'TEST CATALOGUE NAME' => concept_name.name, 'NLIMS CODE' => nlims_code }.each do |type_name, value|
    ConceptAttribute.create!(concept_id: concept_name.concept_id,
                             attribute_type_id: concept_attribute_type(type_name).concept_attribute_type_id,
                             value_reference: value)
  end

  concept_name
end

def concept_attribute_type(name)
  ConceptAttributeType.find_by(name:) || ConceptAttributeType.create!(
    # The column is not auto-increment in the host schema.
    concept_attribute_type_id: (ConceptAttributeType.unscoped.maximum(:concept_attribute_type_id) || 0) + 1,
    name:,
    datatype: 'org.openmrs.customdatatype.datatype.FreeTextDatatype',
    min_occurs: 0
  )
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
