# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HourlyPay, type: :model do
  let(:hourly_pay) { FactoryGirl.build(:hourly_pay, gross_salary: 100) }

  describe '#name' do
    it 'returns a "nice" name' do
      expect(hourly_pay.name).to eq('Gross salary 100 SEK')
    end
  end

  describe '#unit' do
    it 'returns the unit in correct local' do
      expect(hourly_pay.unit).to eq('SEK/hour')
      I18n.with_locale(:sv) do
        expect(hourly_pay.unit).to eq('SEK/timmen')
      end
    end
  end

  describe '#net_salary' do
    it 'returns the correct net salary' do
      expect(hourly_pay.net_salary).to eq(70)
    end
  end

  describe '#rate_excluding_vat' do
    it 'returns the correct rate excluding VAT' do
      expect(hourly_pay.rate_excluding_vat).to eq(140)
    end
  end

  describe '#invoice_rate' do
    it 'returns the same value as #rate_excluding_vat' do
      expect(hourly_pay.invoice_rate).to eq(hourly_pay.rate_excluding_vat)
    end
  end

  describe '#rate_including_vat' do
    it 'returns the correct rate including VAT' do
      expect(hourly_pay.rate_including_vat).to eq(175)
    end
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
