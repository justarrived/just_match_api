# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi::Currency do
  let(:default_headers) { FrilansFinansApi::Client::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }
  let(:client) { FrilansFinansApi::FixtureClient.new }

  describe '#currencies' do
    subject { described_class }

    it 'returns professions' do
      resources = subject.index(client: client).resources
      expect(resources).to be_a(Array)
      expect(resources.first.attributes['name']).to eq('SEK')
    end

    it 'can walk' do
      subject.walk(client: client) do |document|
        resources = document.resources
        expect(resources).to be_a(Array)
        expect(resources.last.attributes['name']).to eq('NOK')
      end
    end
  end
end
