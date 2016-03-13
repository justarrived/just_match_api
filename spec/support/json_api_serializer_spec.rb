# frozen_string_literal: true
require 'spec_helper'

RSpec.describe JsonApiSerializer do
  let(:skill_model) { Skill.new }
  let(:skills_relation) { Skill.none }
  let(:skill_error_model) { Skill.new.tap { |s| s.errors.add(:watman, 'Watman') } }

  let(:serializer) { described_class.new(skill_model, included: []) }
  let(:each_serializer) { described_class.new(skills_relation, included: []) }
  let(:error_serializer) { described_class.new(skill_error_model.errors, included: []) }

  describe '#serializer' do
    it 'returns the serializer for single model' do
      expect(serializer.serializer).to eq(SkillSerializer)
    end

    it 'returns the serializer for plural model' do
      expected_klass = ActiveModel::Serializer::CollectionSerializer
      expect(each_serializer.serializer).to eq(expected_klass)
    end
  end

  describe '#serializer_instance' do
    it 'returns the serializer instance for single model' do
      expect(serializer.serializer_instance).to be_an_instance_of(SkillSerializer)
    end

    it 'returns the serializer instance for plural model' do
      expected_klass = ActiveModel::Serializer::CollectionSerializer
      result = each_serializer.serializer_instance
      expect(result).to be_an_instance_of(expected_klass)
    end

    it 'raises NoMethodError error when no serializer found' do
      expect do
        error_serializer.serializer_instance
      end.to raise_error(NoMethodError, "undefined method `new' for nil:NilClass")
    end
  end

  describe '#serializer' do
    it 'returns JsonApi serializer' do
      expected_klass = ActiveModel::Serializer::Adapter::JsonApi
      expect(serializer.serialize.class).to eq(expected_klass)
    end

    it 'returns the serialized data for single model' do
      expected_data = {
        data: {
          id: '',
          type: 'skills',
          attributes: { name: nil },
          relationships: { language: { data: nil }
          }
        }
      }
      expect(serializer.serialize.serializable_hash).to eq(expected_data)
    end

    it 'returns the serialized data for plural model' do
      expect(each_serializer.serialize.serializable_hash).to eq(data: [])
    end
  end
end
