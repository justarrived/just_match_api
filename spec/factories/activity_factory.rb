# frozen_string_literal: true


FactoryBot.define do
  factory :activity do
    name 'MyString'
  end
end

# == Schema Information
#
# Table name: activities
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  name       :string
#  updated_at :datetime         not null
#
