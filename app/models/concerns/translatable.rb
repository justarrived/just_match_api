# frozen_string_literal: true
module Translatable
  TranslationResult = Struct.new(:translation, :changed_fields)

  extend ActiveSupport::Concern

  included do
    has_many :translations, class_name: "#{name}Translation", foreign_key: "#{name.underscore.downcase}_id", dependent: :destroy # rubocop:disable Metrics/LineLength

    scope :with_translations, -> { includes(:language, :translations) }

    def original_translation
      return if language_id.nil?

      translations.find_by(locale: language.lang_code)
    end
  end

  class_methods do
    attr_reader :translated_fields

    def translates(*attr_names)
      attribute_names = attr_names.map(&:to_sym)
      attr_writer(*attribute_names)

      @translated_fields = attr_names.map(&:to_s)

      define_method(:set_translation) do |t_hash, language_id = self.language_id|
        # NOTE: The problem with this is that the main/parent record needs to be
        #       reloaded otherwise the old text will be returned
        locale = Language.find_by(id: language_id)&.lang_code
        translation = translations.find_or_initialize_by(locale: locale)

        attributes = t_hash.slice(*attribute_names).to_h

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

        # Define convinience methods, i.e #original_name => #name
        define_method(attribute_name) do
          # Check if the instance variable has been set and if so return it
          instance_variable = "@#{attribute_name}"
          if instance_variable_defined?(instance_variable)
            return instance_variable_get(instance_variable)
          end
          # There can't be any translations unless the record has been persisted
          return unless persisted?

          public_send(original_text_method_name)
        end

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

          prioritised_texts.detect { |text| !text.nil? } || public_send(original_text_method_name) # rubocop:disable Metrics/LineLength
        end

        define_method(original_text_method_name) do
          # NOTE: We should store language_id on the translation model breaking DB
          #       normalization just a little bit
          locale = language&.lang_code

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
      end
    end
  end
end
