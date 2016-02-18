# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user) }

    let(:serializer) { UserSerializer.new(resource) }
    let(:serialization) { ActiveModel::Serializer::Adapter.create(serializer) }

    subject do
      JSON.parse(serialization.to_json)['data']
    end

    it 'has a name' do
      expect(subject['attributes']['name']).to eql(resource.name)
    end
  end
end
