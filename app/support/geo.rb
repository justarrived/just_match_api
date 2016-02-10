# frozen_string_literal: true
class Geo
  Coordinates = Struct.new(:latitude, :longitude)

  def self.best_coordinates(address)
    result = Geocoder.search(address).first&.coordinates
    Coordinates.new(*result)
  end
end
