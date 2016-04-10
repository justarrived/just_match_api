# frozen_string_literal: true
require 'rails_helper'

require 'frilans_finans_api/frilans_finans_api'

RSpec.describe FrilansFinansApi::Client do
  let(:default_headers) { described_class::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }

  describe '#professions' do
    subject do
      json = FrilansFinansApi::FixtureClient.new.read(:professions)
      stub_request(:get, "#{base_url}/profession?page=1").
        with(default_headers).
        to_return(status: 200, body: json, headers: {})

      described_class.new
    end

    it 'returns professions array' do
      parsed_body = JSON.parse(subject.professions.body)
      expect(parsed_body['data']).to be_a(Array)
    end
  end
end
