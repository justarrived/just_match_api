# frozen_string_literal: true
require 'spec_helper'
require 'env'

RSpec.describe Env do
  describe '#[]' do
    it 'returns value' do
      env = described_class.new(env: { present_key: :a })
      expect(env[:present_key]).to eq(:a)
    end
  end

  describe '#[]=' do
    it 'sets value' do
      env = described_class.new(env: {})
      env[:present_key] = :a

      expect(env[:present_key]).to eq(:a)
    end
  end

  describe '#key?' do
    it 'returns true if key present' do
      env = described_class.new(env: { present_key: :a })
      expect(env.key?(:present_key)).to eq(true)
    end

    it 'returns true if key present' do
      env = described_class.new(env: {})
      expect(env.key?(:not_present_key)).to eq(false)
    end
  end

  describe '#fetch' do
    context 'no default' do
      it 'fetches value' do
        env = described_class.new(env: { present_key: :a })
        expect(env.fetch(:present_key)).to eq(:a)
      end

      it 'raises key error on missing key' do
        env = described_class.new(env: { present_key: :a })
        expect { env.fetch(:not_present_key) }.to raise_error(KeyError)
      end
    end

    context 'default value arg' do
      it 'fetches value' do
        env = described_class.new(env: { present_key: :a })
        expect(env.fetch(:present_key, :watman)).to eq(:a)
      end

      it 'returns default value when key missing' do
        env = described_class.new(env: { present_key: :a })
        expect(env.fetch(:not_present_key, :watman)).to eq(:watman)
      end
    end

    context 'default value block' do
      it 'fetches value' do
        env = described_class.new(env: { present_key: :a })
        expect(env.fetch(:present_key) { :watman }).to eq(:a)
      end

      it 'returns default value when key missing' do
        env = described_class.new(env: { present_key: :a })
        expect(env.fetch(:not_present_key) { :watman }).to eq(:watman)
      end
    end

    context 'both default arg and default block' do
      it 'fetches value' do
        env = described_class.new(env: { present_key: :a })
        expect(env.fetch(:present_key, :watwoman) { :watman }).to eq(:a)
      end

      it 'returns default value when key missing' do
        env = described_class.new(env: { present_key: :a })
        expect(env.fetch(:not_present_key, :watwoman) { :watman }).to eq(:watman)
      end
    end
  end
end
