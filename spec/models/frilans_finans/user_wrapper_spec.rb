# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinans::UserWrapper do
  describe '#attributes' do
    it 'returns the correct attributes' do
      user = FactoryGirl.build(:user)
      result = described_class.attributes(user)
      expected = {
        email: user.email,
        street: user.street,
        city: nil,
        zip: user.zip,
        country: 'SWEDEN',
        cellphone: user.phone,
        first_name: user.first_name,
        last_name: user.last_name,
        social_security_nr: user.ssn
      }
      expect(result).to eq(expected)
    end
  end
end
