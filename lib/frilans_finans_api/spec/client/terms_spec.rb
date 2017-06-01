# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FrilansFinansApi::Terms do
  let(:base_user_url) { described_class::USER_URL }
  let(:base_company_user_url) { described_class::COMPANY_USER_URL }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'User-Agent' => 'FrilansFinansAPI - Ruby client'
    }
  end
  let(:response_content) { 'watman' }

  describe '#get' do
    before(:each) do
      stub_request(:get, base_user_url).
        with(headers: headers).
        to_return(status: 200, body: response_content, headers: {})

      stub_request(:get, base_company_user_url).
        with(headers: headers).
        to_return(status: 200, body: response_content, headers: {})
    end

    it 'returns contents of user remote file' do
      expect(described_class.get(type: :user)).to eq(response_content)
    end

    it 'returns contents of company user remote file' do
      expect(described_class.get(type: :company)).to eq(response_content)
    end

    it 'raises argument error on unknown type' do
      expect { described_class.get(type: :watman) }.to raise_error(ArgumentError)
    end
  end
end
