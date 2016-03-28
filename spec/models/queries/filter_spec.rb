# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Queries::Filter do
  describe '#filter' do
    context 'no filter_types' do
      subject { described_class }

      it 'can return extact match' do
        category = FactoryGirl.create(:category, name: 'watman')
        result = subject.filter(Category, { name: 'watman' }, {})
        expect(result).to eq([category])
      end

      it 'does *not* return if not an exact match' do
        FactoryGirl.create(:category, name: 'watman')
        result = subject.filter(Category, { name: 'wat' }, {})
        expect(result).to eq([])
      end
    end

    context 'filter_type: starts_with' do
      subject { described_class }

      it 'can return extact match' do
        category = FactoryGirl.create(:category, name: 'watman')
        result = subject.filter(Category, { name: 'watman' }, {})
        expect(result).to eq([category])
      end

      it 'can return if starts_with match' do
        category = FactoryGirl.create(:category, name: 'watman')
        result = subject.filter(Category, { name: 'wat' }, name: :starts_with)
        expect(result).to eq([category])
      end
    end
  end

  describe '#extract_like_query' do
    subject { described_class }

    it 'can return correct like query for contains' do
      expect(subject.extract_like_query(:contains)).to eq("'%', ?, '%'")
    end

    it 'can return correct like query for starts_with' do
      expect(subject.extract_like_query(:starts_with)).to eq("?, '%'")
    end

    it 'can return correct like query for ends_with' do
      expect(subject.extract_like_query(:ends_with)).to eq("'%', ?")
    end

    it 'raises exception on unknown like type' do
      expect { subject.extract_like_query(:watman) }.to raise_error(ArgumentError)
    end
  end
end
