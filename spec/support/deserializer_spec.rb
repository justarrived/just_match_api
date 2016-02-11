# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JsonApiDeserializer do
  let(:params) do
    {
      'data' => {
        'type' => 'users',
        'attributes' => {
          'name' => 'watman'
        }
      }
    }
  end

  it 'returns instance of ActionController::Parameters' do
    result = described_class.parse(params)
    expect(result).to be_a(ActionController::Parameters)
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
