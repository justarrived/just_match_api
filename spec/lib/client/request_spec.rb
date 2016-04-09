# frozen_string_literal: true
require 'rails_helper'

require 'frilans_finans_api/frilans_finans_api'

RSpec.describe FrilansFinansApi::Request do
  let(:default_headers) { described_class::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }

  describe '#professions' do
    subject { described_class.new(page: 1) }

    it 'returns professions array' do
      stub_request(:get, "#{base_url}/profession?page=1").
         with(default_headers).
         to_return(status: 200, body: FFApiFixture.read(:professions), headers: {})

      parsed_body = JSON.parse(subject.professions.body)
      expect(parsed_body['data']).to be_a(Array)
    end
  end
end
