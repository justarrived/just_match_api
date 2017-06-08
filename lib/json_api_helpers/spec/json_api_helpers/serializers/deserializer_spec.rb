# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonApiHelpers::Serializers::Deserializer do
  # HACK: Since this spec file can be run from the main JustMatch application
  #       we need to override the JustMatch test config for these tests in order
  #       to avoid problems. Both the before and after blocks can be removed if this
  #       gem is extracted outside of JustMatch
  before(:each) do
    @old_deserializer_klass = JsonApiHelpers.config.deserializer_klass
    @old_params_klass = JsonApiHelpers.config.params_klass

    JsonApiHelpers.configure do |config|
      config.deserializer_klass = Class.new do
        def self.jsonapi_parse(json_api_hash)
          json_api_hash.dig('data', 'attributes')
        end
      end

      config.params_klass = Class.new do
        def initialize(hash)
          @hash = hash
        end

        def [](name)
          @hash[name.to_s]
        end

        def to_h
          @hash
        end
      end
    end
  end

  after(:each) do
    JsonApiHelpers.configure do |config|
      config.deserializer_klass = @old_deserializer_klass
      config.params_klass = @old_params_klass
    end
  end

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

  it 'can deserialize params' do
    result = described_class.parse(params)
    expect(result[:name]).to eq('watman')
  end

  it 'can deserialize empty params' do
    result = described_class.parse({})
    expect(result.to_h).to eq({})
  end

  it 'ignores params that do not follow the JSON API standard' do
    result = described_class.parse(users: { name: '1' })
    expect(result.to_h).to eq({})
  end
end
