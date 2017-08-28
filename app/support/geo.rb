# frozen_string_literal: true

class Geo
  Coordinates = Struct.new(:latitude, :longitude)
  Place = Struct.new(
    :address,
    :street_name,
    :city,
    :postal_code,
    :state,
    :country_code,
    :longitude,
    :latitude
  )

  def self.best_coordinates(address)
    result = Geocoder.search(address).first&.coordinates
    Coordinates.new(*result)
  end

  def self.best_result(address)
    result = Geocoder.search(address).first
    return Place.new unless result

    # NOTE: Google has an address_components_of_type attribute, while other
    #       geocoder adapters don't (including the test result object)
    city = if result.respond_to?(:address_components_of_type)
             result.address_components_of_type('postal_town')&.
             first&.
             fetch('long_name')
           else
             result.city
           end

    Place.new(
      result.address,
      result.route,
      city,
      result.postal_code,
      result.state,
      result.country_code,
      result.longitude,
      result.latitude
    )
  end
end

# street_number
# route
# political, sublocality, sublocality_level_1
# postal_town
# administrative_area_level_1, political
# country, political
# postal_code
