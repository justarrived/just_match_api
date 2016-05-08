# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinans::UserWrapper do
  describe '#attributes' do
    it 'returns the correct attributes' do
      user = FactoryGirl.build(:user)
      result = described_class.attributes(user)
      expected = {
        user: {
          email: user.email,
          street: user.street,
          city: '',
          zip: user.zip,
          country: 'SWEDEN',
          cellphone: user.phone,
          first_name: user.first_name,
          last_name: user.last_name,
          social_security_number: user.ssn
        }
      }
      expect(result).to eq(expected)
    end

    it 'returns the empty street string if no street present' do
      user = FactoryGirl.build(:user, street: nil)
      result = described_class.attributes(user)
      expect(result.dig(:user, :street)).to eq('')
    end

    it 'returns the empty zip string if no zip present' do
      user = FactoryGirl.build(:user, zip: nil)
      result = described_class.attributes(user)
      expect(result.dig(:user, :zip)).to eq('')
    end
  end
end
