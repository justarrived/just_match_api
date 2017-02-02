# frozen_string_literal: true
ActiveAdmin.register LanguageFilter do
  permit_params do
    [:language_id, :filter_id, :proficiency, :proficiency_by_admin]
  end
end
