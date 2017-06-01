# frozen_string_literal: true

ActiveAdmin.register UserTranslation do
  menu parent: 'Misc'

  filter :user
  filter :language, collection: -> { Language.system_languages.order(:en_name) }
  filter :locale
  filter :description
  filter :job_experience
  filter :education
  filter :competence_text
  filter :created_at
  filter :updated_at

  permit_params do
    %i(body locale)
  end
end
