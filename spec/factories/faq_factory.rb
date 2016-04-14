# frozen_string_literal: true
FactoryGirl.define do
  factory :faq do
    answer 'An answer'
    question 'A question'
    association :language

    factory :faq_for_docs do
      id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
    end
  end
end
