# frozen_string_literal: true
class Filter < ApplicationRecord
  validates :name, presence: true

  has_many :skill_filters
  has_many :skills, through: :skill_filters

  has_many :language_filters
  has_many :languages, through: :language_filters

  has_many :interest_filters
  has_many :interests, through: :interest_filters

  # NOTE: This is necessary for nested activeadmin has_many form
  accepts_nested_attributes_for :interest_filters, allow_destroy: true
  accepts_nested_attributes_for :skill_filters, allow_destroy: true
  accepts_nested_attributes_for :language_filters, allow_destroy: true
end

# == Schema Information
#
# Table name: filters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
