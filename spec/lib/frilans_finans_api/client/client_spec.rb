# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinansApi::Client do
  let(:default_headers) { described_class::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }
  let(:fixture_client) { FrilansFinansApi::FixtureClient.new }

  describe '#professions' do
    subject do
      json = fixture_client.read(:professions)
      url = "#{base_url}/professions?client_id=&client_secret=&grant_type=&page=1"

      stub_request(:get, url).
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns professions array' do
      parsed_body = JSON.parse(subject.professions.body)
      expect(parsed_body['data']).to be_a(Array)
    end
  end

  describe '#create_user' do
    subject do
      json = fixture_client.read(:user)
      url = "#{base_url}/users"

      body = 'data[attributes][first_name]=Anna&grant_type=&client_id=&client_secret='

      stub_request(:post, url).
        with(default_headers.merge(body: body)).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns user' do
      attributes = { first_name: 'Anna' }
      response = subject.create_user(attributes: attributes)
      parsed_body = JSON.parse(response.body)
      id = parsed_body.dig('data', 'id')
      first_name = parsed_body.dig('data', 'attributes', 'first_name')
      expect(first_name).to eq('Anna')
      expect(id).to eq('1')
    end
  end

  describe '#create_company' do
    subject do
      json = fixture_client.read(:company)
      url = "#{base_url}/companies"

      body = 'data[attributes][name]=Acme&grant_type=&client_id=&client_secret='

      stub_request(:post, url).
        with(default_headers.merge(body: body)).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns company' do
      attributes = { name: 'Acme' }
      response = subject.create_company(attributes: attributes)
      parsed_body = JSON.parse(response.body)
      id = parsed_body.dig('data', 'id')
      name = parsed_body.dig('data', 'attributes', 'name')
      expect(name).to eq('Acme')
      expect(id).to eq('1')
    end
  end
end
