# frozen_string_literal: true
ActiveAdmin.register CommunicationTemplateTranslation do
  menu parent: 'Translations'

  permit_params do
    [:language_id, :communication_template_id, :subject, :body]
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
