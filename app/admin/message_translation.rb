# frozen_string_literal: true
ActiveAdmin.register MessageTranslation do
  permit_params do
    [:body, :locale]
  end
end
