# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi::Client do
  before(:each) { stub_frilans_finans_auth_request }
  let(:access_token) { 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' }

  let(:default_headers) do
    headers = FrilansFinansApi::Request::HEADERS.dup
    headers['Authorization'] = "Bearer #{access_token}"
    { headers: headers }
  end
  let(:base_uri) { FrilansFinansApi.base_uri }
  let(:fixture_client) { FrilansFinansApi::FixtureClient.new }

  describe '#professions' do
    subject do
      json = fixture_client.read(:professions)
      url = "#{base_uri}/professions?page=1"

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

  describe '#salaries' do
    let(:invoice_id) { 1 }
    subject do
      json = fixture_client.read(:salaries)
      url = "#{base_uri}/invoices/#{invoice_id}/salaries?page=1"

      stub_request(:get, url).
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns salaries array' do
      parsed_body = JSON.parse(subject.salaries(invoice_id: invoice_id).body)
      expect(parsed_body['data']).to be_a(Array)
    end
  end

  describe '#currencies' do
    subject do
      json = fixture_client.read(:currencies)
      url = "#{base_uri}/currencies?page=1"

      stub_request(:get, url).
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns currencies array' do
      parsed_body = JSON.parse(subject.currencies.body)
      expect(parsed_body['data']).to be_a(Array)
    end

    it 'returns currencies array' do
      parsed_body = JSON.parse(subject.currencies.body)
      expect(parsed_body['data'].first.dig('attributes', 'name')).to eq('SEK')
    end
  end

  describe '#taxes' do
    subject { described_class.new }

    it 'returns taxes array' do
      json = fixture_client.read(:taxes)
      url = "#{base_uri}/taxes?page=1"

      stub_request(:get, url).
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      parsed_body = JSON.parse(subject.taxes.body)
      expect(parsed_body['data']).to be_a(Array)
    end

    # The real test here is actually the request stub rather than the assertion
    it 'can add filter param' do
      json = fixture_client.read(:taxes)
      url = "#{base_uri}/taxes?filter[standard]=1&page=1"

      stub_request(:get, url).
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      parsed_body = JSON.parse(subject.taxes(only_standard: true).body)
      expect(parsed_body['data']).to be_a(Array)
    end
  end

  describe '#create_user' do
    subject do
      json = fixture_client.read(:user)
      url = "#{base_uri}/users"

      body = { first_name: 'Jacob' }.to_json

      stub_request(:post, url).
        with(default_headers.merge(body: body)).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns user' do
      attributes = { first_name: 'Jacob' }
      response = subject.create_user(attributes: attributes)
      parsed_body = JSON.parse(response.body)
      id = parsed_body.dig('data', 'id')
      first_name = parsed_body.dig('data', 'attributes', 'first_name')
      expect(first_name).to eq('Jacob')
      expect(id).to eq('1')
    end
  end

  describe '#create_company' do
    subject do
      json = fixture_client.read(:company)
      url = "#{base_uri}/companies"

      body = { name: 'Acme' }.to_json

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

  describe '#create_invoice' do
    subject do
      json = fixture_client .read(:invoice)
      url = "#{base_uri}/invoices"

      body = {}.to_json

      stub_request(:post, url).
        with(default_headers.merge(body: body)).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns invoice' do
      attributes = {}
      response = subject.create_invoice(attributes: attributes)
      parsed_body = JSON.parse(response.body)
      id = parsed_body.dig('data', 'id')
      expect(id).to eq('1')
    end
  end

  describe '#invoice' do
    subject do
      json = fixture_client.read(:invoice)
      url = "#{base_uri}/invoices/1"

      stub_request(:get, url).
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns invoice' do
      response = subject.invoice(id: 1)
      parsed_body = JSON.parse(response.body)
      id = parsed_body.dig('data', 'id')
      expect(id).to eq('1')
    end
  end

  describe '#update_user' do
    let(:user_id) { 1 }

    subject do
      json = fixture_client.read(:user)
      url = "#{base_uri}/users/#{user_id}"

      body = { first_name: 'Jacob' }.to_json

      stub_request(:patch, url).
        with(default_headers.merge(body: body)).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns user' do
      attributes = { first_name: 'Jacob' }
      response = subject.update_user(attributes: attributes, id: user_id)
      parsed_body = JSON.parse(response.body)
      id = parsed_body.dig('data', 'id')
      first_name = parsed_body.dig('data', 'attributes', 'first_name')
      expect(first_name).to eq('Jacob')
      expect(id).to eq('1')
    end
  end

  describe '#update_invoice' do
    let(:invoice_id) { 1 }
    subject do
      json = fixture_client .read(:invoice)
      url = "#{base_uri}/invoices/#{invoice_id}"

      body = { pre_report: 1 }.to_json

      stub_request(:patch, url).
        with(default_headers.merge(body: body)).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns invoice' do
      attributes = { pre_report: 1 }
      response = subject.update_invoice(id: invoice_id, attributes: attributes)
      parsed_body = JSON.parse(response.body)
      id = parsed_body.dig('data', 'id')
      expect(id).to eq('1')
    end
  end
end
