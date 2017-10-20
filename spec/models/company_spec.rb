# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '#address' do
    let(:company) { FactoryGirl.build(:company, street: '1', zip: '1', city: '1') }

    it 'returns the company address' do
      expect(company.address).to eq('1, 1, 1, Sverige')
    end

    it 'returns the compacted company address' do
      company.city = nil
      expect(company.address).to eq('1, 1, Sverige')
    end
  end

  describe '#logo_image_token=' do
    let(:company) { FactoryGirl.create(:company) }
    let(:company_image) { FactoryGirl.create(:company_image) }

    it 'can set logo image from token' do
      company.logo_image_token = company_image.one_time_token
      expect(company.company_images.first).to eq(company_image)
    end

    it 'does not set token when such token is found' do
      company.logo_image_token = 'invalid token'
      expect(company.company_images.first).to be_nil
    end

    it 'does not set token when token is nil' do
      company.logo_image_token = nil
      expect(company.company_images.first).to be_nil
    end
  end

  describe '#formatted_cin' do
    [
      # input, expected
      %w(XXXXXXXXXX XXXXXX-XXXX),
      %w(xxx xxx),
      %w(xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    ].each do |data|
      input, expected = data

      it 'returns well formatted cin' do
        company = Company.new(cin: input)
        expect(company.formatted_cin).to eq(expected)
      end
    end

    it 'returns nil when passed nil' do
      company = Company.new(cin: nil)
      expect(company.formatted_cin).to be_nil
    end
  end

  describe '#add_protocol_to_website' do
    it 'adds HTTP if missing' do
      company = Company.new(website: 'example.com')
      company.add_protocol_to_website

      expect(company.website).to eq('http://example.com')
    end

    it 'leaves it if HTTPS is present' do
      company = Company.new(website: 'https://example.com')
      company.add_protocol_to_website

      expect(company.website).to eq('https://example.com')
    end

    it 'leaves it if HTTP is present' do
      company = Company.new(website: 'http://example.com')
      company.add_protocol_to_website

      expect(company.website).to eq('http://example.com')
    end

    it 'leaves it if website is blank' do
      website = '   '
      company = Company.new(website: website)
      company.add_protocol_to_website

      expect(company.website).to eq(website)
    end
  end

  describe '#set_default_billing_email' do
    context 'with blank billing_email' do
      it 'sets billing_email from email ' do
        email = 'company@example.com'
        company = Company.new(email: email)
        company.set_default_billing_email

        expect(company.billing_email).to eq(email)
      end
    end

    context 'with billing_email' do
      it 'sets billing_email' do
        billing_email = 'billing@example.com'
        company = Company.new(email: 'company@example.com', billing_email: billing_email)
        company.set_default_billing_email

        expect(company.billing_email).to eq(billing_email)
      end
    end
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  name              :string
#  cin               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  frilans_finans_id :integer
#  website           :string
#  email             :string
#  street            :string
#  zip               :string
#  city              :string
#  phone             :string
#  billing_email     :string
#  municipality      :string
#  staffing_agency   :boolean          default(FALSE)
#  display_name      :string
#  sales_user_id     :integer
#
# Indexes
#
#  index_companies_on_cin                (cin) UNIQUE
#  index_companies_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#
# Foreign Keys
#
#  companies_sales_user_id_fk  (sales_user_id => users.id)
#
