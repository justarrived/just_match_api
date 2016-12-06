# frozen_string_literal: true
ActiveAdmin.register FaqTranslation do
  menu parent: 'Translations'

  permit_params do
    [:question, :answer, :locale, :language_id, :faq_id]
  end
end
