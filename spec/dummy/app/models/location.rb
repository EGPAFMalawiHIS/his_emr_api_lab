# frozen_string_literal: true

class Location < RetirableRecord
  self.table_name = :location
  self.primary_key = :location_id

  belongs_to :parent, class_name: 'Location', foreign_key: :parent_location, optional: true
  has_many :children, inverse_of: :parent
  has_many :tag_maps, class_name: 'LocationTagMap', foreign_key: :location_id

  def self.current
    Thread.current['current_location']
  end

  def self.current=(location)
    Thread.current['current_location'] = location
  end

  def as_json(options = {})
    super(options.merge(include: { parent: {} }))
  end

  def self.current_health_center
    property = GlobalProperty.find_by_property('current_health_center_id')
    health_center = Location.find(property.property_value)

    unless health_center
      logger.warn "Property current_health_center not set: #{e}"
      return nil
    end

    health_center
  end

  def site_id
    Location.current_health_center.location_id.to_s
  end

  def self.current_arv_code
    current_health_center.neighborhood_cell
  rescue StandardError
    nil
  end
end
