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

  index do
    column :id do |translation|
      link_to(translation.id, admin_job_translation_path(translation))
    end
    column :job_id do |translation|
      link_to("##{translation.job_id}", admin_job_path(translation.job_id))
    end
    column :name
    column :language
    column :updated_at

    actions
  end

  show do |job_translation|
    attributes_table do
      row :id
      row :job
      row :name
      row :short_description
      row :description do
        formatter = StringFormatter.new
        formatter.to_html(job_translation.description)&.html_safe # rubocop:disable Rails/OutputSafety, Metrics/LineLength
      end
      row :locale
      row :language
      row :updated_at
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys)

      f.input :job, collection: Job.with_translations
      f.input :language, collection: Language.system_languages.order(:en_name)
      f.input :locale
      f.input :name
      f.input :short_description
      f.input :description, input_html: { markdown: true }
      f.input :tasks_description, input_html: { markdown: true }
      f.input :applicant_description, input_html: { markdown: true }
      f.input :requirements_description, input_html: { markdown: true }
    end

    f.actions
  end

  permit_params do
    %i(
      name
      short_description
      description
      tasks_description
      applicant_description
      requirements_description
      locale
      job_id
      language_id
    )
  end

  controller do
    def scoped_collection
      super.includes(:language)
    end
  end
end
