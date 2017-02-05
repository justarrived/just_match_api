# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinans::CompanyWrapper do
  describe '#attributes' do
    it 'returns the correct attributes' do
      allow(AppConfig).to receive(:frilans_finans_company_creator_user_id).and_return(7)
      company = FactoryGirl.build(:company)
      result = described_class.attributes(company: company)
      expected = {
        name: company.name,
        country: company.country_name.upcase,
        street: company.street,
        city: company.city,
        zip: company.zip,
        send_to_email: company.billing_email,
        user_id: 7
      }
      expect(result).to eq(expected)
    end
  end
end
