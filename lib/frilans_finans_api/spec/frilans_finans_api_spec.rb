# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi do
  it 'has a version number' do
    expect(FrilansFinansApi::VERSION).not_to be(nil)
  end

  it 'has a default client' do
    expect(FrilansFinansApi::DEFAULT_CLIENT_KLASS).to eq(FrilansFinansApi::FixtureClient)
  end

  it 'has a default client returned by #client_klass' do
    expect(FrilansFinansApi.client_klass).to eq(FrilansFinansApi::FixtureClient)
  end

  it 'has a default uri' do
    expect(FrilansFinansApi.base_uri).to eq(FrilansFinansApi::DEFAULT_BASE_URI)
  end
end
