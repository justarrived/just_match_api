# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinans::CompanyWrapper do
  describe '#attributes' do
    it 'returns the correct attributes' do
      user = FactoryGirl.build(:user)
      company = FactoryGirl.build(:company)
      result = described_class.attributes(company: company, user: user)
      expected = {
        company: {
          name: company.name,
          country: company.country_name.upcase,
          street: company.street,
          city: company.city,
          zip: company.zip,
          send_to_email: company.email,
          user_id: user.frilans_finans_id
        }
      }
      expect(result).to eq(expected)
    end
  end
end
