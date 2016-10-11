# frozen_string_literal: true
class HourlyPay < ApplicationRecord
  has_many :jobs

  validates :gross_salary, presence: true, numericality: { only_integer: true }

  scope :active, -> { where(active: true) }

  NET_SALARY_MULTIPLIER = 0.7
  RATE_EXCLUDING_VAT_MULTIPLIER = 1.4
  VAT_MULTIPLIER = 1.25

  def name
    "Gross salary #{gross_salary} SEK"
  end

  def net_salary
    PayCalculator.net_salary(gross_salary)
  end

  def rate_excluding_vat
    PayCalculator.rate_excluding_vat(gross_salary)
  end

  def rate_including_vat
    PayCalculator.rate_including_vat(gross_salary)
  end
end

# == Schema Information
#
# Table name: hourly_pays
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE)
#  currency     :string           default("SEK")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  gross_salary :integer
#
