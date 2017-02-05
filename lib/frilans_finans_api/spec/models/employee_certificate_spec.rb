# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi::EmploymentCertificate do
  let(:default_headers) { FrilansFinansApi::Client::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }
  let(:client) { FrilansFinansApi::FixtureClient.new }

  describe '#create' do
    subject { described_class }

    let(:valid_attributes) do
      json = client.read(:employee_certificate_post)
      data = JSON.parse(json)['data']
      resource = FrilansFinansApi::Resource.new(data)
      resource.attributes
    end

    it 'returns' do
      expect(company.resource.id).to eq('{}')
    end
  end
end
