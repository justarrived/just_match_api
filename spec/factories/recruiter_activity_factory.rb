# frozen_string_literal: true

FactoryBot.define do
  factory :recruiter_activity do
    user nil
    activity nil
    body 'MyText'
    document nil
  end
end
