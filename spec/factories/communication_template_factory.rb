# frozen_string_literal: true
FactoryGirl.define do
  factory :communication_template do
    language nil
    category 'MyString'
    subject 'MyString'
    body 'MyText'
  end
end
