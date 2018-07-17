# frozen_string_literal: true

ActiveAdmin.register LanguageFilter do
  menu parent: 'Filters'

  permit_params do
    %i(language_id filter_id proficiency proficiency_by_admin)
  end
end
