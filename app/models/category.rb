# frozen_string_literal: true
class Category < ApplicationRecord
  INSURANCE_STATUSES = {
    insured: 1,
    assessment_required: 2,
    uninsured: 3
  }.freeze

  has_many :jobs

  validates :name, uniqueness: true, length: { minimum: 3 }, allow_blank: false
  validates :insurance_status, presence: true
  validates :frilans_finans_id, uniqueness: true

  enum insurance_status: INSURANCE_STATUSES

  def display_name
    "##{id} #{name}"
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
