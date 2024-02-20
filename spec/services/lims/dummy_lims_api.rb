# frozen_string_literal: true

class DummyLimsApi
  attr_accessor :created_order, :updated_order

  def initialize
    @id = 0
  end

  def create_order(order)
    self.created_order = order

    @id += 1
    OpenStruct.new(id: "id-#{@id}")
  end

  def update_order(id, order)
    self.updated_order = OpenStruct.new(order:)

    order.merge(id:)
  end
end
