# frozen_string_literal: true
require 'google/cloud/translate'

module GoogleTranslate
  def self.translate(text, from:, to:, api_key: ENV.fetch('GOOGLE_TRANSLATE_API_KEY'))
    translator = Google::Cloud::Translate.new(key: api_key)
    translation = translator.translate(text, from: from, to: to)
    translation.text
  end

  def self.t(*args)
    translate(*args)
  end
end
