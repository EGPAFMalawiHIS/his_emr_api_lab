# frozen_string_literal: true

# Model: ConceptAttributeType
class ConceptAttributeType < RetirableRecord
  self.table_name = 'concept_attribute_type'
  self.primary_key = 'concept_attribute_type_id'

  include Auditable
  include Voidable
  belongs_to :user, class_name: 'User', foreign_key: :creator, primary_key: :user_id, optional: true
  belongs_to :forcer, class_name: 'User', foreign_key: :retired_by, primary_key: :user_id, optional: true
  has_many :concept_attributes, foreign_key: :attribute_type_id, primary_key: :concept_attribute_type_id

  validates :name, presence: true
  validates :min_occurs, presence: true
  # validates :date_created, presence: true
  validates :retired, inclusion: { in: [true, false, 0, 1] }
  # validates :uuid, presence: true

  def self.nlims_code
    find_by_name('NLIMS CODE')
  end

  def self.test_catalogue_name
    find_by_name('TEST CATALOGUE NAME')
  end
end
