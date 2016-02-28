# frozen_string_literal: true
FactoryGirl.define do
  factory :language do
    sequence :lang_code do |index|
      "sv_#{index}"
    end

    trait :eng do
      lang_code 'en'
    end

    factory :language_for_docs do
      id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
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
