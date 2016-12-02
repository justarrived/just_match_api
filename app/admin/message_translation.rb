# frozen_string_literal: true
ActiveAdmin.register MessageTranslation do
  menu parent: 'Translation'

  permit_params do
    [:body, :locale]
  end
end
