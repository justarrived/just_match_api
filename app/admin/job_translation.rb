# frozen_string_literal: true
ActiveAdmin.register JobTranslation do
  menu parent: 'Misc'

  filter :job, collection: -> { Job.with_translations }
  filter :language, collection: -> { Language.system_languages.order(:en_name) }
  filter :locale
  filter :name
  filter :short_description
  filter :description
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.semantic_errors

      f.input :job, collection: Job.with_translations
      f.input :language, collection: Language.system_languages.order(:en_name)
      f.input :locale
      f.input :name
      f.input :short_description
      f.input :description, input_html: { markdown: true }
    end

    f.actions
  end

  permit_params do
    [:name, :short_description, :description, :locale, :job_id, :language_id]
  end
end
