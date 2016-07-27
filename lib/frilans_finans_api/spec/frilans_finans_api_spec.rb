# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi do
  let(:default_client_klass) { FrilansFinansApi::Client }

  it 'has a version number' do
    expect(FrilansFinansApi::VERSION).not_to be_nil
  end

  it 'has a default client' do
    expect(FrilansFinansApi::DEFAULT_CLIENT_KLASS).not_to be_nil
  end

  it 'has a default client returned by #client_klass' do
    expect(FrilansFinansApi.client_klass).not_to be_nil
  end
end
