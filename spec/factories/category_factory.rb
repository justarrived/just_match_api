# frozen_string_literal: true
FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "Category #{n}"
    end
    insurance_status :insured
    ssyk 431

    sequence :frilans_finans_id do |n|
      n
    end

    factory :category_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
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
#  insurance_status  :integer
#  ssyk              :integer
#
# Indexes
#
#  index_categories_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_categories_on_name               (name) UNIQUE
#
