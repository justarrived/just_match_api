# frozen_string_literal: true

require 'postal_code'

class Address < ApplicationRecord
  include Uuidable

  PARTS = %i(
    street1
    street2
    postal_code
    municipality
    city
    state
    country_code
  ).freeze

  geocoded_by :full_street_address
  before_validation :normalize_attributes
  after_validation :geocode_address, if: :should_geocode?

  scope :near_address, (lambda { |query|
    area, distance = query.downcase.split('km:')
    km = distance&.strip&.to_f || 50

    near(area, km, units: :km)
  })

  scope :near_coordinates, (lambda { |lat:, long:, km: 50|
    near([lat, long], km, units: :km)
  })

  def self.within(latitude:, longitude:, distance:)
    near(
      [latitude, longitude],
      distance,
      latitude: self.latitude,
      longitude: self.longitude,
      units: :km
    )
  end

  def full_street_address
    [
      street1,
      street2,
      PostalCode.new(postal_code).to_s,
      municipality,
      city,
      state,
      country_name
    ].reject(&:blank?).join(', ')
  end

  def country_name
    return 'Sweden' if country_code == 'SE'

    country_code
  end

  def address_changed?
    PARTS.any? { |attribute| public_send("#{attribute}_changed?") }
  end

  def should_geocode?
    return false if latitude_changed?
    return false if longitude_changed?

    address_changed?
  end

  def geocode_address
    place = Geo.best_result(full_street_address)

    self.latitude = place.latitude
    self.longitude = place.longitude
  end

  def coordinates?
    return true if longitude && latitude

    false
  end

  def normalize_attributes
    PARTS.each do |attribute|
      input = public_send(attribute)
      next unless input

      value = input.strip
      value = nil if input.blank?
      public_send("#{attribute}=", value)
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id           :bigint(8)        not null, primary key
#  street1      :string
#  street2      :string
#  city         :string
#  state        :string
#  postal_code  :string
#  municipality :string
#  country_code :string
#  uuid         :string(36)
#  latitude     :decimal(15, 10)
#  longitude    :decimal(15, 10)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_addresses_on_uuid  (uuid)
#
