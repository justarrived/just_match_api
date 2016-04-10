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
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  frilans_finans_id :integer
#
# Indexes
#
#  index_categories_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_categories_on_name               (name) UNIQUE
#
