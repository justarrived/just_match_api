# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Document, type: :model do
  it { should have_attached_file(:document) }
  it { should validate_attachment_presence(:document) }
  it do
    should validate_attachment_content_type(:document).
      allowing('application/msword').
      rejecting('text/plain', 'text/xml', 'application/exe')
  end

  it do
    should validate_attachment_size(:document).
      less_than(described_class::DOCUMENT_MAX_MB_SIZE.megabytes)
  end

  described_class::CATEGORIES.each do |name, _value|
    it "has field name translation for document category: #{name}" do
      key = "document.categories.#{name}"
      expect(I18n.t(key)).not_to include('translation missing')
    end

    it "has description translation for document category: #{name}" do
      key = "document.categories.#{name}_description"
      expect(I18n.t(key)).not_to include('translation missing')
    end
  end

  describe '#generate_one_time_token' do
    let(:document) { FactoryGirl.build(:document) }

    it 'generates one time token' do
      document.generate_one_time_token
      expected = SecureGenerator::DEFAULT_TOKEN_LENGTH
      expect(document.one_time_token.length).to eq(expected)
    end

    it 'generates one time token expiry datetime' do
      time = Time.zone.now
      validity_time = described_class::ONE_TIME_TOKEN_VALID_FOR_HOURS.hours
      Timecop.freeze(time) do
        document.generate_one_time_token
        expect(document.one_time_token_expires_at).to eq(time + validity_time)
      end
    end
  end

  describe '#find_by_one_time_token' do
    context 'token still valid' do
      it 'finds and returns document' do
        document = FactoryGirl.create(:document)
        document.generate_one_time_token
        document.save!

        token = document.one_time_token
        expect(described_class.find_by_one_time_token(token)).to eq(document)
      end
    end

    context 'token expired' do
      it 'returns nil' do
        document = FactoryGirl.create(:document)
        document.generate_one_time_token
        document.save!

        token = document.one_time_token
        Timecop.freeze(Time.zone.today + 30) do
          expect(described_class.find_by_one_time_token(token)).to be_nil
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: documents
#
#  id                        :integer          not null, primary key
#  category                  :integer
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  document_file_name        :string
#  document_content_type     :string
#  document_file_size        :integer
#  document_updated_at       :datetime
#
