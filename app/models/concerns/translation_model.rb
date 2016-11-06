# frozen_string_literal: true
module TranslationModel
  extend ActiveSupport::Concern

  included do
    def translates_model_meta
      # NOTE: Translations only belong to one model, so grab the first one
      belongs_to_meta = self.class.belongs_to_models.first
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
