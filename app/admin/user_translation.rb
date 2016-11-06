# frozen_string_literal: true
ActiveAdmin.register UserTranslation do
  permit_params do
    [:body, :locale]
  end
end
