# frozen_string_literal: true

require 'rails_helper'

RSpec.describe URLHelper do
  describe '#starts_with_protocol?' do
    it 'returns true for http' do
      url = 'http://example.com'
      expect(described_class.starts_with_protocol?(url)).to eq(true)
    end

    it 'returns true for https' do
      url = 'https://example.com'
      expect(described_class.starts_with_protocol?(url)).to eq(true)
    end

    it 'returns false otherwise' do
      url = 'example.com'
      expect(described_class.starts_with_protocol?(url)).to eq(false)
    end
  end

  describe '#add_protocol' do
    it 'adds if protocol is missing' do
      url = 'example.com'
      expect(described_class.add_protocol(url)).to eq('http://example.com')
    end

    it 'adds if protocol is missing' do
      url = 'www.example.com'
      expect(described_class.add_protocol(url)).to eq('http://www.example.com')
    end

    it 'leaves it as is otherwise' do
      url = 'https://example.com'
      expect(described_class.add_protocol(url)).to eq('https://example.com')
    end
  end
end
