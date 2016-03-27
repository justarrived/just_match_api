# frozen_string_literal: true
FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "Category #{n}"
    end
  end
end
