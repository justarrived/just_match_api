# frozen_string_literal: true

require 'spec_helper'
require 'utm_url_builder'

RSpec.describe UtmUrlBuilder do
  describe '::build' do
    it 'can build utm_source from default UTM source' do
      old_source = UtmUrlBuilder.default_utm_source
      UtmUrlBuilder.default_utm_source = 'JustTesting'

      expect(described_class.build('/')).to eq('/?utm_source=JustTesting')

      UtmUrlBuilder.default_utm_source = old_source
    end

    it 'raises error if passed invalid URL' do
      expect do
        described_class.build('%%%%', source: 'anything')
      end.to raise_error(URI::InvalidURIError)
    end

    it 'raises ArgumentError if source is nil or empty string' do
      expect do
        described_class.build('asd', source: nil)
      end.to raise_error(ArgumentError)

      expect do
        described_class.build('asd', source: '  ')
      end.to raise_error(ArgumentError)
    end

    it 'returns built URL with some UTM parameters' do
      result = described_class.build(
        '/',
        source: 'source',
        term: 'term',
        content: 'content'
      )

      expected = '/?utm_source=source&utm_term=term&utm_content=content' # rubocop:disable Metrics/LineLength
      expect(result).to eq(expected)
    end

    it 'returns built URL with all UTM parameters' do
      result = described_class.build(
        '/',
        source: 'source',
        medium: 'medium',
        campaign: 'campaign',
        term: 'term',
        content: 'content'
      )

      expected = '/?utm_source=source&utm_medium=medium&utm_campaign=campaign&utm_term=term&utm_content=content' # rubocop:disable Metrics/LineLength
      expect(result).to eq(expected)
    end
  end
end
