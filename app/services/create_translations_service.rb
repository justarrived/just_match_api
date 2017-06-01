# frozen_string_literal: true

require 'i18n/google_translate'
require 'markdowner'
require 'html_sanitizer'

class CreateTranslationsService
  def self.call(translation:, from:, changed: nil, languages: nil)
    new(
      translation: translation,
      from: from,
      changed: changed,
      languages: languages
    ).call
  end

  attr_reader :translation, :from, :changed, :languages

  def initialize(translation:, from:, changed: nil, languages: nil)
    @translation = translation
    @from = from
    @changed = changed
    @languages = languages
  end

  def call
    source_translation_locale = translation.language&.locale

    (languages || Language.machine_translation_languages).map do |language|
      # NOTE: If the language has been explicitly set on the source translation, then
      # don't create an additional translation for that language
      next if source_translation_locale == language.locale

      if from == language.locale
        # Language has been detected, skip sending that to Google Translate and
        # create it from source instead
        next set_translation(attributes_for_translation, language)
      end

      translated_attributes = translate_attributes(
        attributes_for_translation,
        from: from,
        to: language.locale
      )

      set_translation(translated_attributes, language)
    end.compact
  end

  def attributes_for_translation
    attributes = translation.translation_attributes
    # If changed is nil then all fields will be translated
    return attributes unless changed
    attributes.slice(*changed.map(&:to_s))
  end

  def set_translation(attributes, language)
    translation.
      translates_model.
      set_translation(attributes, language)
  end

  def translate_attributes(attributes, from:, to:)
    attributes.inject({}) do |translated, values|
      name, text = values
      translated[name] = translate_text(text, from: from, to: to)
      translated
    end
  end

  def translate_text(text, from:, to:)
    return if text.blank?
    html = Markdowner.to_html(text)
    translation = GoogleTranslate.translate(html, from: from, to: to, type: :html)
    # NOTE: #to_markdown adds "\n" to the end of the string, so lets remove it
    markdown = Markdowner.to_markdown(translation.text).strip
    HTMLSanitizer.sanitize(markdown)
  end
end
