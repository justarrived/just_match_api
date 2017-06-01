# frozen_string_literal: true

class TranferHourlyPayRateToGrossSalaryColumn < ActiveRecord::Migration
  def up
    HourlyPay.all.each do |hourly_pay|
      hourly_pay.update(gross_salary: hourly_pay.rate)
    end
  end

  def down
    HourlyPay.all.each do |hourly_pay|
      hourly_pay.update(gross_salary: nil)
    end
  end
end
