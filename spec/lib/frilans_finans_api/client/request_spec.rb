# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinansApi::Request do
  let(:auth_headers) do
    {
      'Authorization' => 'Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
      'User-Agent' => 'FrilansFinansAPI - Ruby client'
    }
  end
  let(:headers) do
    { 'User-Agent' => 'FrilansFinansAPI - Ruby client' }
  end
  let(:base_uri) { ENV.fetch('FRILANS_FINANS_BASE_URI') }

  describe '#get' do
    before(:each) { stub_frilans_finans_auth_request }

    it 'has access_token after request' do
      stub_request(:get, "#{base_uri}/").
        with(headers: auth_headers).
        to_return(status: 200, body: '', headers: {})

      request = described_class.new
      request.get(uri: '/')
      expect(request.access_token).to eq('x' * 40)
    end
  end

  describe '#_get' do
    it 'can make get request' do
      stub_request(:get, "#{base_uri}/").
        with(headers: headers).
        to_return(status: 200, body: '', headers: {})

      response = described_class.new._get(uri: '/')
      expect(response.code).to eq(200)
    end
  end

  describe '#post' do
    before(:each) { stub_frilans_finans_auth_request }

    it 'has access_token after request' do
      stub_request(:post, "#{base_uri}/").
        with(headers: auth_headers).
        to_return(status: 200, body: '', headers: {})

      request = described_class.new
      request.post(uri: '/')
      expect(request.access_token).to eq('x' * 40)
    end
  end

  describe '#_post' do
    it 'can make post request' do
      stub_request(:post, "#{base_uri}/").
        with(headers: headers).
        to_return(status: 201, body: '', headers: {})

      response = described_class.new._post(uri: '/')
      expect(response.code).to eq(201)
    end
  end
end
