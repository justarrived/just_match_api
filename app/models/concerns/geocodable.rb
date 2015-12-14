module Geocodable
  module InstanceMethods
    def full_street_address
      address
    end

    def validate_geocoding
      unless geocoded?
        # errors.add(:address, 'must be a valid address')
      end
    end
  end

  def self.included(receiver)
    receiver.class_eval do
      geocoded_by :full_street_address
      after_validation :geocode, if: ->(record) { record.address_changed? }
      after_validation :validate_geocoding

      def self.within(lat:, long:, distance:)
        near([lat, long], distance, units: :km)
      end
    end
    receiver.send(:include, InstanceMethods)
  end
end
