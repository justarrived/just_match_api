# frozen_string_literal: true
require 'spec_helper'

# NOTE: This is kept since the "local" test suite for JsonApiHelpers don't have coverage
# for most of the logic there its not clear that we'd want to mock the
# ActiveModelSerializers API, we're using there private(-ish) API and can be good to
# keep around if the compatibility brakes
RSpec.describe JsonApiSerializer do
  let(:id) { '1' }
  let(:skill_model) { Skill.new(id: id) }
  let(:skills_relation) { Skill.none }
  let(:skill_error_model) { Skill.new.tap { |s| s.errors.add(:watman, 'Watman') } }
  let(:current_user) { nil }

  let(:serializer) do
    described_class.new(skill_model, included: [], current_user: current_user)
  end

  let(:each_serializer) do
    described_class.new(skills_relation, included: [], current_user: current_user)
  end

  let(:error_serializer) do
    errors = skill_error_model.errors
    described_class.new(errors, included: [], current_user: current_user)
  end

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
      expected_klass = ActiveModelSerializers::Adapter::JsonApi
      expect(serializer.serialize.class).to eq(expected_klass)
    end

    it 'returns the serialized data for single model' do
      expected_data = {
        data: {
          id: id,
          type: 'skills',
          attributes: {
            name: nil,
            'language-id': nil,
            'translated-text': {
              name: nil,
              'language-id': nil
            }
          },
          relationships: {
            language: { data: nil }
          },
          links: { self: 'https://api.justarrived.se/api/v1/skills/1' }
        }
      }
      expect(serializer.serialize.serializable_hash).to eq(expected_data)
    end

    it 'returns the serialized data for plural model' do
      expect(each_serializer.serialize.serializable_hash).to eq(data: [])
    end
  end
end
