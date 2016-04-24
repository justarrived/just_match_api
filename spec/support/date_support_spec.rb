# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DateSupport do
  describe '#days_appart' do
    it 'returns the number of days appart' do
      days_appart = described_class.days_appart(4.days.ago, 2.days.ago)
      expect(days_appart).to eq(2)
    end
  end

  describe '#work_date_between' do
    it 'works' do
      
    end
  end
end
