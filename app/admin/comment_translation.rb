# frozen_string_literal: true
ActiveAdmin.register CommentTranslation do
  menu parent: 'Translations'

  permit_params do
    [:body, :locale]
  end
end
