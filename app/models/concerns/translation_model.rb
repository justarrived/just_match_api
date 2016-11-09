# frozen_string_literal: true
module TranslationModel
  extend ActiveSupport::Concern

  included do
    belongs_to :language

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
