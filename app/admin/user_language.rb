# frozen_string_literal: true
ActiveAdmin.register UserLanguage do
  menu parent: 'Users'

  permit_params do
    [:user_id, :language_id, :proficiency, :proficiency_by_admin]
  end
end
