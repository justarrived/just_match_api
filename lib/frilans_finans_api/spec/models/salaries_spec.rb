# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FrilansFinansApi::Salary do
  let(:default_headers) { FrilansFinansApi::Client::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }
  let(:client) { FrilansFinansApi::FixtureClient.new }

  describe '#salaries' do
    subject { described_class }

    it 'returns salaries' do
      resources = subject.index(invoice_id: 1, client: client).resources
      expect(resources).to be_a(Array)
      expect(resources.first.attributes['gross_amount']).to eq(2000)
    end
  end
end
