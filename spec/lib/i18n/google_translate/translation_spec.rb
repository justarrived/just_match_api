# frozen_string_literal: true

require 'spec_helper'

require 'i18n/google_translate/translation'

RSpec.describe GoogleTranslate::Translation do
  describe 'text' do
    it 'returns text untouched if type is HTML' do
      result = described_class.new(OpenStruct.new(text: 'Text&#39;'))
      expect(result.text).to eq('Text&#39;')
    end

    it 'unescapes HTML if type is plain' do
      result = described_class.new(OpenStruct.new(text: 'Text&#39;'), type: :plain)
      expect(result.text).to eq("Text'")
    end

    it 'converts <br> tags to \n' do
      result = described_class.new(OpenStruct.new(text: 'Text<br>'), type: :plain)
      expect(result.text).to eq("Text\n")
    end
  end
end
