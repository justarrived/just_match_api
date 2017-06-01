# frozen_string_literal: true

module PayCalculator
  NET_SALARY_MULTIPLIER = 0.7
  RATE_EXCLUDING_VAT_MULTIPLIER = 1.4
  VAT_MULTIPLIER = 1.25

  # NOTE: APPROX. since the exact tax level isn't known here
  def self.net_salary(gross_salary)
    gross_salary * NET_SALARY_MULTIPLIER
  end

  def self.rate_excluding_vat(gross_salary)
    gross_salary * RATE_EXCLUDING_VAT_MULTIPLIER
  end

  def self.rate_including_vat(gross_salary)
    rate_excluding_vat(gross_salary) * VAT_MULTIPLIER
  end
end
