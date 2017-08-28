# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Filter do
  describe '#to_params' do
    it 'returns correct array for simplest type of filter' do
      expected = { a: { column: :a, type: :b } }
      expect(described_class.to_params(a: :b)).to match(expected)
    end

    it 'returns correct array for complex filter' do
      filter = {
        id: :in_list,
        first_name: { translated: :starts_with, column: :fname }
      }
      expected = {
        id: { column: :id, type: :in_list },
        first_name: { column: :fname, translated: :starts_with }
      }
      expect(described_class.to_params(filter)).to match(expected)
    end
  end

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

    context 'filter_type: translated' do
      subject { described_class }

      it 'returns correct results' do
        skill = FactoryGirl.create(:skill_with_translation, name: 'watman')
        skill1 = FactoryGirl.create(:skill_with_translation, name: 'wat1')
        FactoryGirl.create(:skill_with_translation, name: 'tawnam')

        filter = { name: { translated: :starts_with } }
        result = subject.filter(Skill, { name: 'wat' }, filter)
        expect(result).to eq([skill, skill1])
      end
    end

    context 'filter_type: alias' do
      subject { described_class }

      it 'returns correct results' do
        occupation = FactoryGirl.create(:occupation_with_translation, name: 'watman')
        occupation1 = FactoryGirl.create(:occupation_with_translation, name: 'wat1', parent: occupation) # rubocop:disable Metrics/LineLength
        FactoryGirl.create(:occupation_with_translation, name: 'tawnam')

        filter = { parent_id: { alias: :ancestry } }
        result = subject.filter(Occupation, { parent_id: occupation.to_param }, filter)
        expect(result).to eq([occupation1])
      end
    end

    context 'filter_type: in_list' do
      subject { described_class }

      it 'returns correct results' do
        skill = FactoryGirl.create(:skill)
        skill1 = FactoryGirl.create(:skill)
        FactoryGirl.create(:skill)

        filter = { id: :in_list }
        result = subject.filter(Skill, { id: [skill.id, skill1.id].join(',') }, filter)
        expect(result).to eq([skill, skill1])
      end
    end
  end

  describe '::normalize_value' do
    it 'returns nil and empty string array if nil' do
      expect(described_class.normalize_value(nil)).to eq([nil, ''])
    end

    it 'returns nil and empty string array if empty string' do
      expect(described_class.normalize_value('')).to eq([nil, ''])
    end

    ['  ', 'yo', [:wat], { wat: :man }].each do |value|
      it "returns value untouched for #{value}" do
        expect(described_class.normalize_value(value)).to eq(value)
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
