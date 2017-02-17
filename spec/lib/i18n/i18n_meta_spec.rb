# frozen_string_literal: true
require 'spec_helper'
require 'i18n/i18n_meta'

RSpec.describe I18nMeta do
  describe '::meta' do
    it 'returns default meta data for unknown locale' do
      expect(described_class.meta(:wat)).to eq(direction: :ltr, fallbacks: %w(en))
    end
  end

  describe '::direction' do
    it 'returns the direction of the locale' do
      expect(described_class.direction(:ar)).to eq(:rtl)
      expect(described_class.direction(:en)).to eq(:ltr)
    end
  end

  describe '::rtl?' do
    it 'returns the direction of the locale' do
      expect(described_class.rtl?(:ar)).to eq(true)
      expect(described_class.rtl?(:en)).to eq(false)
    end
  end

  describe '::ltr?' do
    it 'returns the direction of the locale' do
      expect(described_class.ltr?(:ar)).to eq(false)
      expect(described_class.ltr?(:en)).to eq(true)
    end
  end

  describe '::fallbacks' do
    it 'returns fallbacks for locale' do
      expect(described_class.fallbacks(:fa_AF)).to eq(%w(fa en))
      expect(described_class.fallbacks(:ar)).to eq(%w(en))
    end
  end

  describe '::fallbacks_hash' do
    it 'returns correct fallbacks hash' do
      expected = {
        'fa_AF' => %w(fa en),
        'ps' => %w(fa_AF fa en),
        'fa' => %w(en),
        'ti' => %w(en),
        'en' => %w(sv),
        'sv' => %w(en),
        'ku' => %w(en),
        'ar' => %w(en)
      }
      expect(described_class.fallbacks_hash).to eq(expected)
    end
  end
end
