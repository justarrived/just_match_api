# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserImage, type: :model do
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
    let(:user_image) { FactoryGirl.build(:user_image) }

    it 'generates one time token' do
      user_image.generate_one_time_token
      expect(user_image.one_time_token.length).to eq(36)
    end

    it 'generates one time token expiry datetime' do
      time = Time.zone.now
      validity_time = described_class::ONE_TIME_TOKEN_VALID_FOR_HOURS.hours
      Timecop.freeze(time) do
        user_image.generate_one_time_token
        expect(user_image.one_time_token_expires_at).to eq(time + validity_time)
      end
    end
  end

  describe '#find_by_one_time_token' do
    context 'token still valid' do
      it 'finds and returns user_image' do
        user_image = FactoryGirl.create(:user_image)
        user_image.generate_one_time_token
        user_image.save!

        token = user_image.one_time_token
        expect(described_class.find_by_one_time_token(token)).to eq(user_image)
      end
    end

    context 'token expired' do
      it 'returns nil' do
        user_image = FactoryGirl.create(:user_image)
        user_image.generate_one_time_token
        user_image.save!

        token = user_image.one_time_token
        Timecop.freeze(Time.zone.today + 30) do
          expect(described_class.find_by_one_time_token(token)).to be_nil
        end
      end
    end
  end
end
