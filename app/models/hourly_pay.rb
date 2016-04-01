# frozen_string_literal: true
class HourlyPay < ApplicationRecord
  has_many :jobs

  validates :rate, presence: true, numericality: { only_integer: true }

  scope :active, -> { where(active: true) }
end

# == Schema Information
#
# Table name: hourly_pays
#
#  id         :integer          not null, primary key
#  active     :boolean          default(FALSE)
#  rate       :integer
#  currency   :string           default("SEK")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
