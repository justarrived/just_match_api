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

  permit_params do
    [:name, :short_description, :description, :locale]
  end
end
