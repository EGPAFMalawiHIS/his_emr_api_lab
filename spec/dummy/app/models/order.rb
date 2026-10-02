# frozen_string_literal: true

class Order < VoidableRecord
  self.table_name = :orders
  self.primary_key = :order_id

  after_void :clear_dispensed_drugs

  belongs_to :order_type
  belongs_to :concept
  belongs_to :encounter
  belongs_to :patient
  belongs_to :provider, foreign_key: 'orderer', class_name: 'User', optional: true

  validates_presence_of :patient_id, :concept_id, :encounter_id

  has_many :observations
  has_one :drug_order
  has_one :lims_acknowledgement_status, foreign_key: :order_id
end
