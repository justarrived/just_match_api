# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analytics do
  describe '::track' do
    it 'tracks event' do
      allow_any_instance_of(Ahoy::Tracker).to receive(:track).and_return(true)
      expect(described_class.track('Label')).to eq(true)
    end
  end

  describe '#track' do
    it 'tracks event' do
      allow_any_instance_of(Ahoy::Tracker).to receive(:track).and_return(true)
      analytics = described_class.new
      expect(analytics.track('Label')).to eq(true)
    end
  end
end
