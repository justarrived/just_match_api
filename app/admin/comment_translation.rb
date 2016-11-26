# frozen_string_literal: true
ActiveAdmin.register CommentTranslation do
  permit_params do
    [:body, :locale]
  end
end
