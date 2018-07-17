# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street1 'MyString'
    street2 nil
    city 'Lund'
    state nil
    postal_code '22352'
    municipality nil
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
