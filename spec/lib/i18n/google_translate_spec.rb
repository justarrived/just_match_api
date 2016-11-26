# frozen_string_literal: true
require 'spec_helper'
require 'i18n/google_translate'

RSpec.describe GoogleTranslate do
  let(:text) { 'Hello' }
  let(:translated_text) { 'Hej' }
  let(:google_translate_mock) do
    Class.new(Struct.new(:key)) do
      def self.translate(*_args)
        Struct.new(:text).new('Hej')
      end
    end
  end

  subject do
    allow(Google::Cloud::Translate).to receive(:new).and_return(google_translate_mock)
    described_class
  end

  describe '#translate' do
    it 'translanslates the given text' do
      result = subject.translate(text, from: :en, to: :sv, api_key: 'xxx')
      expect(result).to eq(translated_text)
    end
  end

  describe '#t' do
    it 'produces the same result as #translate' do
      translate_result = subject.translate(text, from: :en, to: :sv, api_key: 'xxx')
      t_result = subject.t(text, from: :en, to: :sv)
      expect(t_result).to eq(translate_result)
    end
  end
end
