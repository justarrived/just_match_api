# frozen_string_literal: true

class HourlyPay < ApplicationRecord
  has_many :jobs

  validates :gross_salary, presence: true, numericality: { only_integer: true }

  scope :active, -> { where(active: true) }

  def name
    "Gross salary #{gross_salary} SEK"
  end

  def display_name
    "##{id} Gross salary #{gross_salary} SEK"
  end

  def unit
    I18n.t('units.currency_per_hour', currency: currency)
  end

  def gross_salary_with_unit
    NumberFormatter.new.to_unit(gross_salary, unit)
  end

  def net_salary
    PayCalculator.net_salary(gross_salary)
  end

  def rate_excluding_vat
    PayCalculator.rate_excluding_vat(gross_salary)
  end
  alias_method :invoice_rate, :rate_excluding_vat

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
