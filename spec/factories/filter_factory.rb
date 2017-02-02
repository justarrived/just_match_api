# frozen_string_literal: true
FactoryGirl.define do
  factory :filter do
    name 'MyString'
  end
end

# == Schema Information
#
# Table name: filters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
