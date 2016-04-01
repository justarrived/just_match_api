# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :jobs

  validates :name, uniqueness: true, length: { minimum: 3 }, allow_blank: false
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
