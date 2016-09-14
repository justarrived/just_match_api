# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HourlyPayPolicy do
  subject { described_class.new(nil, HourlyPay.new) }

  permissions :index?, :calculate? do
    it 'allows access for everyone' do
      expect(subject.index?).to eq(true)
    end
  end

  describe 'scope' do
    it 'returns active hourly pays' do
      active_hourly_pay = FactoryGirl.create(:hourly_pay, active: true)
      FactoryGirl.create(:hourly_pay, active: false)
      expect(subject.scope.length).to eq(1)
      expect(subject.scope.first).to eq(active_hourly_pay)
    end
  end
end
