# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NumberFormatter do
  subject { described_class.new }

  describe '#to_currency' do
    [
      # Arabic locale
      { number: 123_123, locale: :ar, expected: '123،123 SEK' },
      { number: 123, locale: :ar, expected: '123 SEK' },
      { number: 123_123.46, locale: :ar, precision: 2, expected: '123،123.46 SEK' },
      { number: 123_123.4, locale: :ar, precision: 2, expected: '123،123.4 SEK' },
      # Swedish locale
      { number: 123_123, locale: :sv, expected: '123 123 SEK' },
      { number: 123, locale: :sv, expected: '123 SEK' },
      { number: 123_123, locale: :sv, precision: 2, expected: '123 123,0 SEK' },
      # English locale
      { number: 123_123, locale: :en, expected: '123,123 SEK' },
      { number: 123, locale: :en, expected: '123 SEK' },
      { number: 123_123, locale: :en, precision: 2, expected: '123,123.0 SEK' },
      { number: 123_123, locale: :en, unit: 'kr', expected: '123,123 kr' },
      { number: nil, locale: :en, expected: nil },
      { number: '', locale: :en, expected: nil },
      { number: '  ', locale: :en, expected: nil }
    ].each do |data|
      number = data[:number]
      locale = data[:locale]
      expected = data[:expected]
      precision = data[:precision]
      unit = data[:unit]

      test_args = ["number '#{number}'", "locale '#{locale}'"]
      test_args << "precision '#{precision}'" if precision
      test_args << "unit '#{unit}'" if unit

      it "returns a correctly formatted value for #{test_args.join(', ')}" do
        args = { locale: locale }
        args[:precision] = precision if precision
        args[:unit] = unit if unit

        result = subject.to_currency(number, **args)
        expect(result).to eq(expected)
      end
    end
  end
end
