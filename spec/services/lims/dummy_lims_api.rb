# frozen_string_literal: true

class DummyLimsApi
  attr_accessor :created_order, :updated_order

  def create_order(order)
    self.created_order = order

    OpenStruct.new(_id: 1, tracking_number: order[:accession_number])
  end

  def update_order(id, order)
    self.updated_order = OpenStruct.new(id: id, order: order)

    OpenStruct.new(_id: 1, tracking_number: order[:accession_number])
  end
end
