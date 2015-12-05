module Geocodable
  module ClassMethods
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

  def Geocodable.included(receiver)
    receiver.class_eval do
      geocoded_by :full_street_address
      after_validation :geocode, if: ->(record){ record.address_changed? }
      after_validation :validate_geocoding
    end
    receiver.send(:include, InstanceMethods)
  end
end
