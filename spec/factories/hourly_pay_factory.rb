# frozen_string_literal: true
FactoryGirl.define do
  factory :hourly_pay do
    active true
    rate 100
    currency 'SEK'

    factory :inactive_hourly_pay do
      active false
    end

    factory :hourly_pay_for_docs do
      id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: hourly_pays
#
#  id         :integer          not null, primary key
#  active     :boolean          default(FALSE)
#  rate       :integer
#  currency   :string           default("SEK")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
