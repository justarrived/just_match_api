# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PayCalculator do
  let(:gross_salary) { 100 }

  describe '#net_salary' do
    let(:value) { described_class.net_salary(gross_salary) }

    it 'returns correct value' do
      expect(value).to eq(70.0)
    end
  end

  describe '#rate_excluding_vat' do
    let(:value) { described_class.rate_excluding_vat(gross_salary) }

    it 'returns correct value' do
      expect(value).to eq(140.0)
    end
  end

  describe '#rate_including_vat' do
    let(:value) { described_class.rate_including_vat(gross_salary) }

    it 'returns correct value' do
      expect(value).to eq(175.0)
    end
  end
end
