# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonApiHelpers::Serializers::Relationships do
  describe '#to_h' do
    it 'can return a single relationship' do
      relationships = described_class.new
      relationships.add(relation: 'author', id: '1', type: 'users')

      expected = { 'author' => { id: '1', type: 'users' } }
      expect(relationships.to_h).to eq(expected)
    end

    it 'can return multiple relationships' do
      relationships = described_class.new
      relationships.add(relation: 'author', id: '1', type: 'users')
      relationships.add(relation: 'receiver', id: '2', type: 'users')

      expected = {
        'author' => { id: '1', type: 'users' },
        'receiver' => { id: '2', type: 'users' }
      }
      expect(relationships.to_h).to eq(expected)
    end
  end
end
