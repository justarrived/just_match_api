# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GoogleMapsUrl do
  let(:base_url) { described_class::BASE_URL }

  it 'has the correct base url' do
    expect(base_url).to eq('https://maps.google.com/?q=')
  end

  describe '#build' do
    it 'returns a correctly escaped URL' do
      expect(described_class.build('@')).to eq("#{base_url}%40")
    end
  end
end
