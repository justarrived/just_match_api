# frozen_string_literal: true
FactoryGirl.define do
  factory :rating do
    association :to_user, factory: :user
    association :from_user, factory: :user
    association :job
    score 3
  end
end
