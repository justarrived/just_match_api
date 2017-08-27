# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#full_street_address' do
    [
      [{ street1: 'street1', street2: 'street2' }, 'street1, street2'],
      [{
        street1: 'Bankgatan 14C',
        city: 'Lund',
        postal_code: '22352',
        country_code: 'SE'
      }, 'Bankgatan 14C, 223 52, Lund, Sweden'],
      [{
        street1: 'Bankgatan 14C',
        postal_code: '22352',
        country_code: 'SE'
      }, 'Bankgatan 14C, 223 52, Sweden'],
      [{
        street1: 'Bankgatan 14C',
        postal_code: '22352'
      }, 'Bankgatan 14C, 223 52'],
      [{
        street1: 'Bankgatan 14C',
        street2: 'Bankgatan 14B',
        city: 'Lund',
        postal_code: '22352',
        country_code: 'SE'
      }, 'Bankgatan 14C, Bankgatan 14B, 223 52, Lund, Sweden']
    ].each do |data|
      attributes, expected = data

      it 'returns the full street address' do
        address = described_class.new(attributes)
        expect(address.full_street_address).to eq(expected)
      end
    end
  end

  describe '#coordinates?' do
    it 'returns true if both longitude and latitude is set' do
      expect(Address.new(longitude: 13, latitude: 13).coordinates?).to eq(true)
    end

    it 'returns true unless both longitude and latitude is set' do
      expect(Address.new.coordinates?).to eq(false)
    end
  end

  describe '#normalize_attributes' do
    %i(
      street1
      street2
      postal_code
      municipality
      city
      state
      country_code
    ).each do |attribute|
      it "normalizes #{attribute}" do
        address = described_class.new(attribute => "  #{attribute}  ")
        address.normalize_attributes
        expect(address.public_send(attribute)).to eq(attribute.to_s)
      end

      it "normalizes #{attribute} to nil if string is blank" do
        address = described_class.new(attribute => '    ')
        address.normalize_attributes
        expect(address.public_send(attribute)).to be_nil
      end
    end
  end

  describe 'address_changed?' do
    %i(
      street1
      street2
      postal_code
      municipality
      city
      state
      country_code
    ).each do |attribute|
      it "returns true if #{attribute} has been changed" do
        address = described_class.new(attribute => attribute.to_s)
        expect(address.address_changed?).to eq(true)
      end
    end

    it 'returns false if no address fields has been changed' do
      expect(described_class.new.address_changed?).to eq(false)
    end
  end

  describe '#country_name' do
    it 'returns correct name when country_code is SE' do
      expect(described_class.new(country_code: 'SE').country_name).to eq('Sweden')
    end

    it 'returns country_code if country_code is unknown' do
      expect(described_class.new(country_code: 'LL').country_name).to eq('LL')
    end
  end

  describe '#validates_country_code'

  describe '#geocode_address' do
    it 'sets longitude, latitude' do
      longitude = 13
      latitude = 13

      coordninates = OpenStruct.new(longitude: longitude, latitude: latitude)
      allow(Geo).to receive(:best_result).and_return(coordninates)

      address = described_class.new.tap(&:geocode_address)
      expect(address.latitude).to eq(latitude)
      expect(address.longitude).to eq(longitude)
    end
  end

  describe '#should_geocode?' do
    it 'returns false if latitude has changed' do
      address = described_class.new(latitude: 13)
      expect(address.should_geocode?).to eq(false)
    end

    it 'returns false if longitude has changed' do
      address = described_class.new(longitude: 13)
      expect(address.should_geocode?).to eq(false)
    end

    it 'returns false if address_changed? is false' do
      address = described_class.new
      expect(address.should_geocode?).to eq(false)
    end

    it 'returns true if latitude and longitude is unchanged and address has changed' do
      address = described_class.new(street1: '13')
      expect(address.should_geocode?).to eq(true)
    end
  end

  describe '#uuid' do
    it 'does not set if uuid is already set' do
      jds = described_class.new(uuid: 'watman')
      jds.validate

      expect(jds.uuid).to eq('watman')
    end

    it 'is present after being validated' do
      jds = described_class.new
      jds.validate

      expect(jds.uuid.length).to eq(36)
    end

    it 'is nil before being validated' do
      expect(described_class.new.uuid).to be_nil
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id           :integer          not null, primary key
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
