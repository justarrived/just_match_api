# frozen_string_literal: true
require 'rails_helper'

require 'frilans_finans_api/frilans_finans_api'

RSpec.describe FrilansFinansApi::Profession do
  let(:default_headers) { FrilansFinansApi::Request::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }

  describe '#professions' do
    subject do
      stub_request(:get, "#{base_url}/profession?page=1").
         with(default_headers).
         to_return(status: 200, body: FFApiFixture.read(:professions), headers: {})

      described_class.index
    end

    it 'returns professions' do
      resources = subject.resources
      expect(subject.resources).to be_a(Array)
      expect(subject.resources.first[:title]).to eq('Test profession')
    end
  end
end
