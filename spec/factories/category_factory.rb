# frozen_string_literal: true
FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "Category #{n}"
    end

    sequence :frilans_finans_id do |n|
      n
    end
  end
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
