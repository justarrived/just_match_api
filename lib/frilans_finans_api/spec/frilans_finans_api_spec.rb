# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi do
  let(:default_client_klass) { FrilansFinansApi::Client }

  it 'has a version number' do
    expect(FrilansFinansApi::VERSION).not_to be_nil
  end

  describe '#config' do
    it 'is present' do
      expect(described_class.config).to be_a(described_class::Configuration)
    end
  end
end
