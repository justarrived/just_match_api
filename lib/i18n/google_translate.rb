# frozen_string_literal: true

require 'google/cloud/translate'

require 'i18n/google_translate/detection'
require 'i18n/google_translate/query'
require 'i18n/google_translate/translation'

module GoogleTranslate
  def self.translate(text, to:, from: nil, type: :html, api_key: nil)
    translator = build_translator(api_key: api_key)
    query = Query.new(text, type: type)
    Translation.new(translator.translate(query.to_s, from: from, to: to), type: type)
  end

  def self.t(*args)
    translate(*args)
  end

  def self.detect(text, api_key: nil)
    detector = build_translator(api_key: api_key)
    Detection.new(detector.detect(text))
  end

  def self.build_translator(api_key:)
    key = api_key || AppSecrets.google_translate_api_key
    Google::Cloud::Translate.new(key: key)
  end
end
