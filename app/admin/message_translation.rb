# frozen_string_literal: true
ActiveAdmin.register MessageTranslation do
  menu parent: 'Misc'

  permit_params do
    [:body, :locale]
  end
end
