# frozen_string_literal: true

require 'seeds/base_seed'

class HourlyPaySeed < BaseSeed
  DEFAULT_ALLOWED_RATES = [105, 115, 125].freeze

  def self.call
    new.call
  end

  def call
    log_seed(HourlyPay) do
      DEFAULT_ALLOWED_RATES.each do |rate|
        HourlyPay.find_or_create_by!(gross_salary: rate, active: true)
      end
    end
  end
end
