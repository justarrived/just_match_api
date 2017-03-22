# frozen_string_literal: true
require 'i18n/google_translate'
require 'utils/array_utils'

module MachineTranslationService
  TranslateAttributesResult = Struct.new(:source_locale, :attributes)

  def self.call(translation:, language:, ignore_attributes: [])
    # TODO: Not sure why this is needed, probably wrong somewhere else
    #       so this early return should (probably) be removed
    # NOTE: This _might_ be legit, since #translation can be updated between calling this method
    return if translation.locale == language.locale

    translated_result = remote_translate_attributes(
      attributes: translation.translation_attributes,
      from_locale: translation.locale,
      to_locale: language.locale,
      ignore_attributes: ignore_attributes
    )

    # NOTE: Doing the update like this is a bit awkward, since each language that should
    #       be translated will potentially update the, source language...
    #       The end result will be the same, though it seems weird to update the source
    #       multiple times
    source_locale = translated_result.source_locale
    source_language = Language.find_by_locale(source_locale)
    unless source_language == translation.language && source_locale == translation.locale
      translation.update(locale: source_locale, language: source_language)
    end

    translation.
      translates_model.
      set_translation(translated_result.attributes, language)
  end

  def self.remote_translate_attributes(attributes:, from_locale:, to_locale:, ignore_attributes:) # rubocop:disable Metrics/LineLength
    source_locale = from_locale
    detected_locales = []
    translated_attributes = { locale: to_locale }

    attributes.each do |name_string, text|
      attribute_name = name_string.to_sym
      next if ignore_attributes.include?(attribute_name)
      translated_attributes[attribute_name] = nil # Reset the field
      next if text.blank?

      translation = GoogleTranslate.translate(text, from: from_locale, to: to_locale)
      translated_attributes[attribute_name] = translation.text

      next unless translation.detected?

      detected_locales << translation.from
    end

    # If source_locale isn't already set, pick the most detected locale
    source_locale = ArrayUtils.most_common(detected_locales) if source_locale.nil?
    TranslateAttributesResult.new(source_locale, translated_attributes)
  end
end
