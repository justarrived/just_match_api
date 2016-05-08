# frozen_string_literal: true
require 'seeds/base_seed'

class HourlyPaySeed < BaseSeed
  DEFAULT_ALLOWED_RATES = [70, 80, 100].freeze

  def self.call
    new.call
  end

  def call
    log_seed(HourlyPay) do
      DEFAULT_ALLOWED_RATES.each do |rate|
        HourlyPay.find_or_create_by!(rate: rate, active: true)
      end
    end
  end
end
