# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi do
  it 'has a version number' do
    expect(FrilansFinansApi::VERSION).not_to be(nil)
  end

  it 'has a default client' do
    expect(FrilansFinansApi::DEFAULT_CLIENT_KLASS).to eq(FrilansFinansApi::FixtureClient)
  end
end
