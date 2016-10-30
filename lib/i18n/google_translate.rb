# frozen_string_literal: true
require 'google/cloud/translate'

class GoogleTranslate
  def initialize(api_key: ENV.fetch('GOOGLE_TRANSLATE_API_KEY'))
    @translator = Google::Cloud::Translate.new(key: api_key)
  end

  def translate(text, from:, to:)
    translation = @translator.translate(text, from: from, to: to)
    translation.text
  end
  alias_method :t, :translate
end
