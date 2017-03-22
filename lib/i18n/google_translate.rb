# frozen_string_literal: true
require 'google/cloud/translate'

module GoogleTranslate
  def self.translate(text, to:, from: nil, api_key: nil)
    translator = build_translator(api_key: api_key)
    translator.translate(text, from: from, to: to)
  end

  def self.t(*args)
    translate(*args)
  end

  def self.detect(text, api_key: nil)
    detector = build_translator(api_key: api_key)
    detector.detect(text)
  end

  def self.build_translator(api_key:)
    key = api_key || AppSecrets.google_translate_api_key
    Google::Cloud::Translate.new(key: key)
  end
end
