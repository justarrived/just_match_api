# frozen_string_literal: true
module TranslationModel
  extend ActiveSupport::Concern

  included do
    def translates_model
      # NOTE: Translations only belong to one model, so grab the first one
      belongs_to_meta = self.class.belongs_to_models.first
      public_send(belongs_to_meta[:relation_name])
    end

    def translation_attributes
      translated_fields = translates_model.class.translated_fields.map(&:to_s)
      attributes.slice(*translated_fields)
    end
  end
end
