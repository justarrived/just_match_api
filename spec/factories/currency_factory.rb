# frozen_string_literal: true
FactoryGirl.define do
  factory :currency do
    frilans_finans_id 1
    currency_code 'SEK'
  end
end

# == Schema Information
#
# Table name: currencies
#
#  id                :integer          not null, primary key
#  currency_code     :string
#  frilans_finans_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
