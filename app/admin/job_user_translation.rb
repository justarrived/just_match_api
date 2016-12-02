# frozen_string_literal: true
ActiveAdmin.register JobUserTranslation do
  menu parent: 'Translation'

  permit_params do
    [:apply_message, :locale]
  end
end
