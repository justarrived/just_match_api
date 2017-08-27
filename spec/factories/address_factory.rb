FactoryGirl.define do
  factory :address do
    street1 "MyString"
    street2 "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    municipality "MyString"
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
