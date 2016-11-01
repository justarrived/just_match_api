# frozen_string_literal: true
module Translatable
  extend ActiveSupport::Concern

  included do
    TRANSLATION_KLASS_NAME = "#{name}Translation".freeze
    TRANSLATION_KLASS = TRANSLATION_KLASS_NAME.constantize

    has_many :translations, class_name: TRANSLATION_KLASS_NAME, foreign_key: "#{name.downcase}_id", dependent: :destroy # rubocop:disable Metrics/LineLength
  end

  class_methods do
    def translates(*attribute_names)
      attribute_names.each do |attribute_name|
        original_method_name = "original_#{attribute_name}"

        define_method("translated_#{attribute_name}") do
          locale = I18n.locale.to_s
          locale_fallbacks = I18N_FALLBACKS[locale]

          prioritised_texts = []
          translations.each do |translation|
            return translation.public_send(attribute_name) if locale == translation.locale

            index = locale_fallbacks.index(translation.locale)
            if index
              text = translation.public_send(attribute_name)
              prioritised_texts.insert(index, text)
            end
          end

          prioritised_texts.detect { |text| !text.nil? } || public_send(original_method_name) # rubocop:disable Metrics/LineLength
        end

        define_method(original_method_name) do
          # TODO: We should store language_id on the transltion model braking DB
          #       normalization just a little bit, this can cause gnarly N+1 queries..
          locale = language.lang_code

          translations.each do |translation|
            if translation.locale == locale
              return translation.public_send(attribute_name)
            end
          end

          # This shouldn't happen! All resources should have an original language!
          context = {
            resource: {
              name: self.class.name,
              id: id,
              language_id: language_id
            }
          }
          ErrorNotifier.send('Resource is missing original language!', context: context)
          nil
        end

        define_method("add_#{attribute_name}_translation") do |content, language_id:|
          locale = Language.find_by(id: language_id)&.lang_code
          translation = TRANSLATION_KLASS.new(attribute_name => content, locale: locale)

          translations << translation
        end

        define_method("update_#{attribute_name}_translation") do |content, language_id: self.language_id| # rubocop:disable Metrics/LineLength
          # TODO: The problem with this is that the main/parent record needs to be reloaded
          #       otherwise the old text will be returned
          locale = Language.find_by(id: language_id)&.lang_code
          translation = translations.find_or_initialize_by(locale: locale)
          translation.attributes = { attribute_name => content }
          translation.save!
        end
      end
    end
  end
end
