# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :jobs

  validates :name, uniqueness: true, length: { minimum: 3 }, allow_blank: false
  validates :frilans_finans_id, uniqueness: true
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
