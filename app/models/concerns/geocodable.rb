module Geocodable
  module ClassMethods
    after_validation :geocode,
      if: ->(record){ record.address_changed? }
    after_validation :validate_lat_long

    def within(lat:, long:, distance: 20)
      near([lat, long], distance, units: :km)
    end
  end
  
  module InstanceMethods
    def full_street_address
      address
    end

    def validate_geocoding
      unless geocoded?
        errors.add(:address_error, 'Must be a valid address')
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend(ClassMethods)
    receiver.send(:include, InstanceMethods)
  end
end