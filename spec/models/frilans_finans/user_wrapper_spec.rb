# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinans::UserWrapper do
  describe '#attributes' do
    let(:account_clearing_number) { '8000-2' }
    let(:account_number) { '0000000000' }

    it 'returns the correct attributes' do
      user = FactoryGirl.build(
        :user,
        ssn: '890101-0101',
        account_clearing_number: account_clearing_number,
        account_number: account_number
      )
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
          social_security_number: '8901010101'.to_i,
          account_clearing_number: account_clearing_number,
          account_number: account_number
        }
      }
      expect(result).to eq(expected)
    end

    context 'when ssn is nil' do
      it 'returns no social_security_number key' do
        user = FactoryGirl.build(:user, ssn: nil)
        result = described_class.attributes(user)
        expect(result[:user].key?(:social_security_number)).to eq(false)
      end
    end

    context 'when ssn is blank string' do
      it 'returns no social_security_number key' do
        user = FactoryGirl.build(:user, ssn: ' ')
        result = described_class.attributes(user)
        expect(result[:user].key?(:social_security_number)).to eq(false)
      end
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
