# frozen_string_literal: true
require 'google/cloud/translate'

module GoogleTranslate
  def self.translate(text, to:, from: nil, api_key: AppSecrets.google_translate_api_key)
    translator = Google::Cloud::Translate.new(key: api_key)
    translation = translator.translate(text, from: from, to: to)
    translation
  end

  def self.t(*args)
    translate(*args)
  end
end
