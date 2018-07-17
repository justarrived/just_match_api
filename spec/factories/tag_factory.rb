# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    color 'MyString'
    name 'MyString'
  end
end

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  color      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
