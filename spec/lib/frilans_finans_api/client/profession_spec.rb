# frozen_string_literal: true
require 'rails_helper'

require 'frilans_finans_api/frilans_finans_api'

RSpec.describe FrilansFinansApi::Profession do
  let(:default_headers) { FrilansFinansApi::Client::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }

  describe '#professions' do
    subject do
      json = FrilansFinansApi::FixtureClient.new.read(:professions)

      stub_request(:get, "#{base_url}/profession?page=1").
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      stub_request(:get, "#{base_url}/profession?page=2").
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      described_class
    end

    it 'returns professions' do
      resources = subject.index.resources
      expect(resources).to be_a(Array)
      expect(resources.first.attributes['title']).to eq('designer 1')
    end

    it 'can walk' do
      subject.walk do |document|
        resources = document.resources
        expect(resources).to be_a(Array)
        expect(resources.first.attributes['title']).to eq('designer 1')
      end
    end
  end
end
