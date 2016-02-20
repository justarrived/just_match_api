# frozen_string_literal: true
FactoryGirl.define do
  factory :language do
    lang_code 'sv'

    trait :eng do
      lang_code 'en'
    end

    factory :language_for_docs do
      id 1
      created_at Date.new(2016, 02, 10)
      updated_at Date.new(2016, 02, 12)
    end
  end
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  lang_code  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
