# frozen_string_literal: true

FactoryGirl.define do
  factory :contact do
    name 'Watman'
    email 'watman@example.com'
    body 'I am Watman!'

    factory :contact_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end
