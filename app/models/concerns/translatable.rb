# frozen_string_literal: true
module Translatable
  TranslationResult = Struct.new(:translation, :changed_fields)

  extend ActiveSupport::Concern

  included do
    has_many :translations, class_name: "#{name}Translation", foreign_key: "#{name.underscore.downcase}_id", dependent: :destroy # rubocop:disable Metrics/LineLength

    scope :with_translations, -> { includes(:language, :translations) }

    def original_translation
      return if language.nil?

      translations.find_by(locale: language.lang_code)
    end
  end

  class_methods do
    attr_reader :translated_fields

    def translates(*attr_names)
      attribute_names = attr_names.map(&:to_sym)
      attr_writer(*attribute_names)

      @translated_fields = attr_names.map(&:to_s)

      define_method(:set_translation) do |t_hash, language = self.language|
        # Unset all translatable instance variables when setting translations, otherwise
        # we risk to return outdated information. This is really a code smell.. and
        # we shouldn't set instance variables on the model at all, but instead handle
        # it elesewhere
        attribute_names.each do |attribute_name|
          instance_variable = "@#{attribute_name}"
          next unless instance_variable_defined?(instance_variable)
          remove_instance_variable(instance_variable)
        end

        attributes = t_hash.slice(*attribute_names).to_h

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

        define_method(:find_translation) do |for_locale: I18n.locale, fallback: true|
          locale = for_locale.to_s
          @_translation_for ||= {}
          @_translation_for[locale] ||= begin
            locale_fallbacks = I18N_FALLBACKS[locale]

            prioritised_texts = []
            translations.each do |translation|
              return translation if translation.locale == locale
              return unless fallback

              index = locale_fallbacks.index(translation.locale)
              prioritised_texts.insert(index, translation) if index
            end

            # NOTE: Consider fallback on original translation if nothing else is found
            prioritised_texts.detect { |translation| !translation.nil? }
          end
        end

        define_method("translated_#{attribute_name}") do
          find_translation&.public_send(attribute_name)
        end

        define_method(:translated_language_id) { find_translation&.language_id }
        define_method(:original_language_id) { language_id }

        define_method(original_text_method_name) do
          locale = language&.lang_code
          translation = find_translation(for_locale: locale, fallback: false)
          return translation.public_send(attribute_name) unless translation.nil?

          # NOTE: This shouldn't happen! All resources should have an original language!
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
      end
    end
  end
end
