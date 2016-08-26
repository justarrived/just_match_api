# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CountriesSerializer do
  describe '#serializeble_resource' do
    it 'returns all countries' do
      total = described_class.serializeble_resource.to_h.dig(:meta, :total)
      expect(total).to eq(249)
    end

    context 'with name filter' do
      it 'returns all countries' do
        resource = described_class.serializeble_resource(filter: { name: 'swe' })
        total = resource.to_h.dig(:meta, :total)
        expect(total).to eq(1)
      end
    end
  end
end
