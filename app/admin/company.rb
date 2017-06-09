# frozen_string_literal: true

ActiveAdmin.register Company do
  menu parent: 'Jobs'

  batch_action :destroy, false

  scope :all, default: true
  scope :needs_frilans_finans_id

  filter :name
  filter :email
  filter :billing_email
  filter :phone
  filter :cin
  filter :street
  filter :city
  filter :created_at

  index do
    column :id
    column :name
    column :cin
    column :frilans_finans_id
    column :email
    column :phone
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :name
      row :cin
      row :billing_email
      row :website
      row :phone
      row :email
      row :street
      row :zip
      row :city
      row :frilans_finans_id
      row :short_description
      row :description
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  sidebar :relations, only: %i(show edit) do
    company_query = AdminHelpers::Link.query(:company_id, company.id)

    ul do
      li(
        link_to(
          I18n.t('admin.counts.owned_jobs', count: company.owned_jobs.count),
          admin_jobs_path + company_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.translations', count: company.translations.count),
          admin_company_translations_path + company_query
        )
      )
    end

    hr

    ul do
      company.users.each do |user|
        li link_to(user.display_name, admin_user_path(user))
      end
    end
  end

  set_company_translation = lambda do |company, permitted_params|
    return unless company.persisted? && company.valid?

    translation_params = {
      short_description: permitted_params.dig(:company, :short_description),
      description: permitted_params.dig(:company, :description)
    }
    language = Language.find_by(id: permitted_params.dig(:company, :language_id))
    company.set_translation(translation_params, language)
  end

  after_save do |company|
    set_company_translation.call(company, permitted_params)
  end

  form do |f|
    f.semantic_errors

    f.inputs I18n.t('admin.company.form.main_form_section_title') do
      f.input :name
      f.input :cin
      f.input :frilans_finans_id
      f.input :website
      f.input :email
      f.input :street
      f.input :zip
      f.input :city
      f.input(
        :municipality,
        as: :select,
        collection: Arbetsformedlingen::MunicipalityCode.to_form_array(name_only: true),
        hint: I18n.t('admin.company.form.municipality_hint')
      )
      f.input :phone
      f.input :billing_email
      f.input :language, as: :select, collection: Language.system_languages
      f.input :short_description, as: :string
      f.input :description, as: :text, input_html: { markdown: true }
    end

    f.actions
  end

  permit_params do
    %i(
      name
      cin
      created_at
      updated_at
      frilans_finans_id
      website
      email
      street
      zip
      city
      municipality
      billing_email
      phone
      short_description
      description
      language_id
    )
  end
end
