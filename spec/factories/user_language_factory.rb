# frozen_string_literal: true
FactoryGirl.define do
  factory :user_language do
    association :user
    association :language

    factory :user_language_for_docs do
      id 1
      created_at Date.new(2016, 02, 10)
      updated_at Date.new(2016, 02, 12)
    end
  end
end
