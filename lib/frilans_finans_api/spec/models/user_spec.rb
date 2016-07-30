# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi::User do
  let(:default_headers) { FrilansFinansApi::Client::HEADERS }
  let(:base_url) { 'https://frilansfinans.se/api' }
  let(:client) { FrilansFinansApi::FixtureClient.new }

  describe '#create' do
    subject { described_class }

    let(:valid_attributes) do
      json = client.read(:user_post)
      data = JSON.parse(json)['data']
      resource = FrilansFinansApi::Resource.new(data)
      resource.attributes
    end

    it 'returns user' do
      user = subject.create(attributes: valid_attributes, client: client)
      expect(user.resource.attributes['first_name']).to eq('Jacob')
    end
  end

  describe '#update' do
    subject { described_class }

    let(:valid_attributes) do
      json = client.read(:user_post)
      data = JSON.parse(json)['data']
      resource = FrilansFinansApi::Resource.new(data)
      resource.attributes
    end

    it 'returns user' do
      user = subject.update(id: '1', attributes: valid_attributes, client: client)
      expect(user.resource.attributes['first_name']).to eq('Jacob')
    end
  end
end
