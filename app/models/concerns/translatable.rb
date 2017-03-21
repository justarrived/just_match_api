# frozen_string_literal: true
module Translatable
  TranslationResult = Struct.new(:translation, :changed_fields)

  extend ActiveSupport::Concern

  included do
    has_many :translations, class_name: "#{name}Translation", foreign_key: "#{name.underscore.downcase}_id", dependent: :destroy # rubocop:disable Metrics/LineLength

    scope :with_translations, -> { includes(:language, :translations) }

    def original_translation
      translations.find_by(locale: language&.lang_code)
    end
  end

  class_methods do
    attr_reader :translated_fields

    def translates(*attr_names)
      attribute_names = attr_names.map(&:to_sym)
      attr_writer(*attribute_names)

      @translated_fields = attr_names.map(&:to_s)

      define_method(:set_translation) do |t_hash, language = nil|
        attributes = t_hash.slice(*attribute_names).to_h

        # NOTE: We can't/shouldn't do this always, since a user might have Arabic as their
        #       language, but write their work experience in Swedish
        #       We should however allow #language to be specified _explicitly_
        # language ||= self.language

        # NOTE: When the language is unknown, it will be nil
        translation = translations.find_or_initialize_by(language: language)
        translation.locale = language&.lang_code
        translation.assign_attributes(attributes)
        changed_fields = translation.changed_translation_fields

        translation.save!

        TranslationResult.new(translation, changed_fields)
      end

      # Atribute helpers
      attribute_names.each do |attribute_name|
        original_text_method_name = "original_#{attribute_name}"

        if instance_methods.include?(attribute_name)
          fail "Method name collision! `#{attribute_name}' method already exists."
        end

        # Define convinience methods, i.e define #name as an alias for #original_name
        define_method(attribute_name) do
          # If the instance variable has been set that means that someone has written
          # that attribute to the model, in that case return the written attribute
          # Note that this is a code smell.. the real issue is that the attributes are
          # set first on the model and not on explicitly on the translation model,
          # its like this now for model validation reasons
          instance_variable = "@#{attribute_name}"
          if instance_variable_defined?(instance_variable)
            return instance_variable_get(instance_variable)
          end
          # There can't be any translations unless the record has been persisted
          return unless persisted?

          # Get the attribute from the translation table
          public_send(original_text_method_name)
        end

        define_method(:find_translation) do |locale: I18n.locale, fallback: true|
          for_locale = locale.to_s
          @_translation_for ||= {}
          @_translation_for[for_locale] ||= begin
            locale_fallbacks = I18nMeta.fallbacks(for_locale)

            prioritised_texts = []
            translations.each do |translation|
              return translation if translation.locale == for_locale

              index = locale_fallbacks.index(translation.locale)
              prioritised_texts.insert(index, translation) if index
            end

            return nil unless fallback

            fallback_translation = prioritised_texts.detect do |translation|
              !translation.nil?
            end

            fallback_translation || translations.first # fallback or original translation
          end
        end

        define_method("translated_#{attribute_name}") do
          find_translation&.public_send(attribute_name)
        end

        define_method(:translated_language_id) { find_translation&.language_id }
        define_method(:original_language_id) { language_id }

        define_method(original_text_method_name) do
          locale = language&.lang_code
          translation = find_translation(locale: locale)

          translation&.public_send(attribute_name)
        end
      end
    end
  end
end
