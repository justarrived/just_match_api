# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CountriesSerializer do
  describe '#serializeble_resource' do
    let(:key_transform) { :dash }
    let(:filter) { {} }
    subject do
      described_class.serializeble_resource(key_transform: key_transform, filter: filter)
    end

    it 'returns all countries' do
      total = subject.to_h.dig(:meta, :total)
      expect(total).to eq(249)
    end

    context 'with name filter' do
      let(:filter) { { name: 'swe' } }

      it 'returns all countries' do
        total = subject.to_h.dig(:meta, :total)
        expect(total).to eq(1)
      end
    end
  end
end
