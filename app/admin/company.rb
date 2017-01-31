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
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  sidebar :relations, only: [:show, :edit] do
    company_query = AdminHelpers::Link.query(:company_id, company.id)

    ul do
      li(
        link_to(
          I18n.t('admin.counts.owned_jobs', count: company.owned_jobs.count),
          admin_jobs_path + company_query
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

  permit_params do
    [
      :name,
      :cin,
      :created_at,
      :updated_at,
      :frilans_finans_id,
      :website,
      :email,
      :street,
      :zip,
      :city,
      :billing_email,
      :phone
    ]
  end
end
