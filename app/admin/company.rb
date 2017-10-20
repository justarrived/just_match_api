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

  include AdminHelpers::MachineTranslation::Actions

  index do
    column :id
    column :name
    column :cin
    column :billing_email
    column :sales_user
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :name
      row :cin
      row :billing_email
      row :staffing_agency
      row :sales_user
      row :website
      row :phone
      row :email
      row :street
      row :zip
      row :city
      row :frilans_finans_id
      row :short_description
      row :description
      row :industries do |company|
        safe_join(
          company.industries.map { |i| link_to(i.name, admin_industry_path(i)) },
          ', '
        )
      end
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
    render partial: 'admin/companies/form', locals: { f: f }
  end

  permit_params do
    [
      :name,
      :display_name,
      :cin,
      :created_at,
      :updated_at,
      :frilans_finans_id,
      :website,
      :email,
      :street,
      :zip,
      :city,
      :municipality,
      :billing_email,
      :phone,
      :short_description,
      :description,
      :language_id,
      :staffing_agency,
      company_industries_attributes: %i(industry_id),
      users_attributes: %i(
        system_language_id
        email
        first_name
        last_name
        managed
        password
      )
    ]
  end
end
