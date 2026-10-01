# frozen_string_literal: true

# Model: ConceptAttribute
class ConceptAttribute < VoidableRecord
  self.table_name = 'concept_attribute'
  self.primary_key = 'concept_attribute_id'

  include Auditable
  include Voidable

  belongs_to :user, class_name: 'User', foreign_key: :creator, primary_key: :user_id, optional: true
  belongs_to :voider, class_name: 'User', foreign_key: :voided_by, primary_key: :user_id, optional: true
  belongs_to :concept, foreign_key: :concept_id, primary_key: :concept_id, optional: true
  belongs_to :attribute_type, foreign_key: :attribute_type_id, primary_key: :concept_attribute_type_id, optional: true,
                              class_name: 'ConceptAttributeType'

  validates :concept_id, presence: true
  validates :attribute_type_id, presence: true
  validates :value_reference, presence: true
  # # validates :uuid, presence: true
  # validates :creator, presence: true
  # validates :date_created, presence: true
  validates :voided, inclusion: { in: [true, false, 0, 1] }
end
