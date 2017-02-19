# frozen_string_literal: true
ActiveAdmin.register UserLanguage do
  menu parent: 'Users'

  filter :language
  filter :proficiency
  filter :proficiency_by_admin
  filter :created_at

  index do
    selectable_column

    column :id
    column :user
    column :language
    column :proficiency do |user_language|
      "#{user_language.proficiency || '-'}/#{user_language.proficiency_by_admin || '-'}"
    end
    column :updated_at
  end

  permit_params do
    [:user_id, :language_id, :proficiency, :proficiency_by_admin]
  end

  controller do
    def scoped_collection
      super.includes(:user, :language)
    end
  end
end
