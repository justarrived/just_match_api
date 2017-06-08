# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyImage, type: :model do
  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it do
    should validate_attachment_content_type(:image).
      allowing('image/png', 'image/gif').
      rejecting('text/plain', 'text/xml')
  end
  it do
    should validate_attachment_size(:image).
      less_than(described_class::IMAGE_MAX_MB_SIZE.megabytes)
  end

  describe '#generate_one_time_token' do
    let(:company_image) { FactoryGirl.build(:company_image) }

    it 'generates one time token' do
      company_image.generate_one_time_token
      expected = SecureGenerator::DEFAULT_TOKEN_LENGTH
      expect(company_image.one_time_token.length).to eq(expected)
    end

    it 'generates one time token expiry datetime' do
      time = Time.zone.now
      validity_time = described_class::ONE_TIME_TOKEN_VALID_FOR_HOURS.hours
      Timecop.freeze(time) do
        company_image.generate_one_time_token
        expect(company_image.one_time_token_expires_at).to eq(time + validity_time)
      end
    end
  end

  describe '#find_by_one_time_token' do
    context 'token still valid' do
      it 'finds and returns company_image' do
        company_image = FactoryGirl.create(:company_image)
        company_image.generate_one_time_token
        company_image.save!

        token = company_image.one_time_token
        expect(described_class.find_by_one_time_token(token)).to eq(company_image)
      end
    end

    context 'token expired' do
      it 'returns nil' do
        company_image = FactoryGirl.create(:company_image)
        company_image.generate_one_time_token
        company_image.save!

        token = company_image.one_time_token
        Timecop.freeze(Time.zone.today + 30) do
          expect(described_class.find_by_one_time_token(token)).to be_nil
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: company_images
#
#  id                        :integer          not null, primary key
#  one_time_token_expires_at :datetime
#  one_time_token            :string
#  company_id                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  image_file_name           :string
#  image_content_type        :string
#  image_file_size           :integer
#  image_updated_at          :datetime
#
# Indexes
#
#  index_company_images_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
