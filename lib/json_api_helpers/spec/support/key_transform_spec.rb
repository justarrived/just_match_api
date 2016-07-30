# frozen_string_literal: true

# Converted to RSpec from https://github.com/rails-api/active_model_serializers/blob/a1826186e556b4aa6cbe2a2588df8b2186e06252/test/active_model_serializers/key_transform_test.rb
RSpec.describe JsonApiHelpers::KeyTransform do
  let(:obj) { Object.new }

  describe '#camel' do
    let(:scenarios) do
      [
        {
          value: { "some-key": 'value' },
          expected: { SomeKey: 'value' }
        },
        {
          value: { someKey: 'value' },
          expected: { SomeKey: 'value' }
        },
        {
          value: { some_key: 'value' },
          expected: { SomeKey: 'value' }
        },
        {
          value: { 'some-key' => 'value' },
          expected: { 'SomeKey' => 'value' }
        },
        {
          value: { 'someKey' => 'value' },
          expected: { 'SomeKey' => 'value' }
        },
        {
          value: { 'some_key' => 'value' },
          expected: { 'SomeKey' => 'value' }
        },
        {
          value: :"some-value",
          expected: :SomeValue
        },
        {
          value: :some_value,
          expected: :SomeValue
        },
        {
          value: :someValue,
          expected: :SomeValue
        },
        {
          value: 'some-value',
          expected: 'SomeValue'
        },
        {
          value: 'someValue',
          expected: 'SomeValue'
        },
        {
          value: 'some_value',
          expected: 'SomeValue'
        },
        {
          value: obj,
          expected: obj
        },
        {
          value: nil,
          expected: nil
        }
      ]
    end

    it 'works' do
      scenarios.each do |s|
        result = described_class.camel(s[:value])
        expect(s[:expected]).to eq(result)
      end
    end
  end

  describe '#camel_lower' do
    let(:scenarios) do
      [
        {
          value: { "some-key": 'value' },
          expected: { someKey: 'value' }
        },
        {
          value: { SomeKey: 'value' },
          expected: { someKey: 'value' }
        },
        {
          value: { some_key: 'value' },
          expected: { someKey: 'value' }
        },
        {
          value: { 'some-key' => 'value' },
          expected: { 'someKey' => 'value' }
        },
        {
          value: { 'SomeKey' => 'value' },
          expected: { 'someKey' => 'value' }
        },
        {
          value: { 'some_key' => 'value' },
          expected: { 'someKey' => 'value' }
        },
        {
          value: :"some-value",
          expected: :someValue
        },
        {
          value: :SomeValue,
          expected: :someValue
        },
        {
          value: :some_value,
          expected: :someValue
        },
        {
          value: 'some-value',
          expected: 'someValue'
        },
        {
          value: 'SomeValue',
          expected: 'someValue'
        },
        {
          value: 'some_value',
          expected: 'someValue'
        },
        {
          value: obj,
          expected: obj
        },
        {
          value: nil,
          expected: nil
        }
      ]
    end

    it 'works' do
      scenarios.each do |s|
        result = described_class.camel_lower(s[:value])
        expect(s[:expected]).to eq(result)
      end
    end
  end

  describe '#dash' do
    let(:scenarios) do
      [
        {
          value: { some_key: 'value' },
          expected: { "some-key": 'value' }
        },
        {
          value: { 'some_key' => 'value' },
          expected: { 'some-key' => 'value' }
        },
        {
          value: { SomeKey: 'value' },
          expected: { "some-key": 'value' }
        },
        {
          value: { 'SomeKey' => 'value' },
          expected: { 'some-key' => 'value' }
        },
        {
          value: { someKey: 'value' },
          expected: { "some-key": 'value' }
        },
        {
          value: { 'someKey' => 'value' },
          expected: { 'some-key' => 'value' }
        },
        {
          value: :some_value,
          expected: :"some-value"
        },
        {
          value: :SomeValue,
          expected: :"some-value"
        },
        {
          value: 'SomeValue',
          expected: 'some-value'
        },
        {
          value: :someValue,
          expected: :"some-value"
        },
        {
          value: 'someValue',
          expected: 'some-value'
        },
        {
          value: obj,
          expected: obj
        },
        {
          value: nil,
          expected: nil
        }
      ]
    end

    it 'works' do
      scenarios.each do |s|
        result = described_class.dash(s[:value])
        expect(s[:expected]).to eq(result)
      end
    end
  end

  describe '#underscore' do
    let(:scenarios) do
      [
        {
          value: { "some-key": 'value' },
          expected: { some_key: 'value' }
        },
        {
          value: { 'some-key' => 'value' },
          expected: { 'some_key' => 'value' }
        },
        {
          value: { SomeKey: 'value' },
          expected: { some_key: 'value' }
        },
        {
          value: { 'SomeKey' => 'value' },
          expected: { 'some_key' => 'value' }
        },
        {
          value: { someKey: 'value' },
          expected: { some_key: 'value' }
        },
        {
          value: { 'someKey' => 'value' },
          expected: { 'some_key' => 'value' }
        },
        {
          value: :"some-value",
          expected: :some_value
        },
        {
          value: :SomeValue,
          expected: :some_value
        },
        {
          value: :someValue,
          expected: :some_value
        },
        {
          value: 'some-value',
          expected: 'some_value'
        },
        {
          value: 'SomeValue',
          expected: 'some_value'
        },
        {
          value: 'someValue',
          expected: 'some_value'
        },
        {
          value: obj,
          expected: obj
        },
        {
          value: nil,
          expected: nil
        }
      ]
    end

    it 'works' do
      scenarios.each do |s|
        result = described_class.underscore(s[:value])
        expect(s[:expected]).to eq(result)
      end
    end
  end
end
