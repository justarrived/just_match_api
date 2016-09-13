# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '#find_frilans_finans_user' do
    let(:company) { FactoryGirl.build(:company) }

    it 'returns first user that has frilans finans id' do
      FactoryGirl.create(:user, company: company)
      FactoryGirl.create(:user, company: company, frilans_finans_id: 10)
      FactoryGirl.create(:user, company: company, frilans_finans_id: 11)
      expect(company.find_frilans_finans_user.frilans_finans_id).to eq(10)
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
#
# Indexes
#
#  index_companies_on_cin                (cin) UNIQUE
#  index_companies_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#
