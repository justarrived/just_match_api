# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    association :to_user, factory: :user
    association :from_user, factory: :user
    association :job
    score 3

    factory :rating_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end
