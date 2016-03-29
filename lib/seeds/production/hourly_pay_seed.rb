# frozen_string_literal: true
class HourlyPaySeed
  DEFAULT_ALLOWED_RATES = [70, 80, 100].freeze

  def self.call
    new.call
  end

  def call
    DEFAULT_ALLOWED_RATES.each do |rate|
      HourlyPay.create!(rate: rate, active: true)
    end
  end
end
