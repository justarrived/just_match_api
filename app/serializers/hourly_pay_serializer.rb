# frozen_string_literal: true
class HourlyPaySerializer < ApplicationSerializer
  ATTRIBUTES = [
    :gross_salary, :net_salary, :rate_excluding_vat, :rate_including_vat, :active,
    :currency
  ].freeze

  attributes ATTRIBUTES

  attribute :gross_salary_formatted do
    to_currency(object.gross_salary, unit: object.unit)
  end

  attribute :net_salary_formatted do
    to_currency(object.net_salary, unit: object.unit)
  end

  link(:self) { api_v1_hourly_pay_url(object) }
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
