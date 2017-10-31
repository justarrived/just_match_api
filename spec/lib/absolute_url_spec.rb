# frozen_string_literal: true

require 'spec_helper'
require 'absolute_url'

RSpec.describe AbsoluteUrl do
  describe '#valid?' do
    it 'passes when its a valid absolute url' do
      expect(AbsoluteUrl.valid?('https://example.com/')).to eq(true)
    end

    [
      'example.com/',
      '/test.com',
      '/test',
      '',
      {},
      [],
      nil
    ].each do |input|
      it "returns false for #{input}" do
        expect(AbsoluteUrl.valid?(input)).to eq(false)
      end
    end
  end
end
