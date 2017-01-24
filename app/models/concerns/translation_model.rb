# frozen_string_literal: true
module TranslationModel
  extend ActiveSupport::Concern

  included do
    belongs_to :language

    unless Rails.env.test? # We need to generate locales in tests..
      validates :language, presence: true
      validates :locale, length: { minimum: 2, maximum: 2 }, allow_blank: false
      validate :validate_locale_eql_language
    end

    def validate_locale_eql_language
      return if language.nil?
      return if language.lang_code == locale

      errors.add(:locale, I18n.t('admin.translation.locale_language_missmatch'))
    end

    def translates_model_meta
      # Find the first model that includes the Translatable module,
      # thats the model thats being translated
      self.class.belongs_to_models.detect do |model_meta|
        model_meta[:model_klass].ancestors.include?(Translatable)
      end
    end

    def translates_model
      public_send(translates_model_meta[:relation_name])
    end

    def translated_fields
      translates_model_meta[:model_klass].translated_fields
    end

    def translation_attributes
      attributes.slice(*translated_fields)
    end

    def changed_translation_fields
      translated_fields.select { |field| public_send("#{field}_changed?") }
    end

    def unchanged_translation_fields
      translated_fields - changed_translation_fields
    end
  end
end
