# frozen_string_literal: true
ActiveAdmin.register JobTranslation do
  menu parent: 'Translation'

  permit_params do
    [:name, :short_description, :description, :locale]
  end
end
