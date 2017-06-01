# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonApiHelpers::Serializers::Deserializer do
  let(:params) do
    params_hash = {
      'data' => {
        'type' => 'users',
        'attributes' => {
          'name' => 'watman'
        }
      }
    }
    JsonApiHelpers.config.params_klass.new(params_hash)
  end

  it 'can deserialize params' do
    result = described_class.parse(params)[:name]
    expect(result).to eq('watman')
  end

  it 'can deserialize empty params' do
    result = described_class.parse({})
    expect(result).to eq({})
  end

  it 'ignores params that do not follow the JSON API standard' do
    result = described_class.parse(users: { name: '1' })
    expect(result).to eq({})
  end
end
