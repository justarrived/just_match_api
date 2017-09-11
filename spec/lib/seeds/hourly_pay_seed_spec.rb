# frozen_string_literal: true

require 'rails_helper'

require 'seeds/production/hourly_pay_seed'

RSpec.describe HourlyPaySeed do
  it 'creates default hourly pays' do
    expected_length = described_class::DEFAULT_ALLOWED_RATES.length

    expect do
      described_class.call
    end.to change(HourlyPay, :count).by(expected_length)
  end
end
