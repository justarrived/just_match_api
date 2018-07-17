# frozen_string_literal: true

class AddressSerializer < ApplicationSerializer
  ATTRIBUTES = Address::PARTS + %i(longitude latitude)

  attributes ATTRIBUTES
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
