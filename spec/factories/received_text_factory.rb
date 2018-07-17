# frozen_string_literal: true

FactoryBot.define do
  factory :received_text do
    from_number 'MyString'
    to_number 'MyString'
    body 'MyString'
  end
end

# == Schema Information
#
# Table name: received_texts
#
#  id          :integer          not null, primary key
#  from_number :string
#  to_number   :string
#  body        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
