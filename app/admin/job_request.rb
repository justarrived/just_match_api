# frozen_string_literal: true
ActiveAdmin.register JobRequest do
  menu parent: 'Misc'

  scope :all, default: true
  scope :pending
  scope :finished

  filter :company_name
  filter :contact_string
  filter :assignment
  filter :job_scope
  filter :job_specification
  filter :language_requirements
  filter :job_at_date
  filter :responsible
  filter :suitable_candidates
  filter :comment
  filter :finished

  index do
    selectable_column

    column :finished
    column :company_name
    column :responsible
    column :contact_string
    column :language_requirements
    column :job_at_date
    column :created_at

    actions
  end

  permit_params do
    [
      :company_name,
      :contact_string,
      :assignment,
      :job_scope,
      :job_specification,
      :language_requirements,
      :job_at_date,
      :responsible,
      :suitable_candidates,
      :comment,
      :finished
    ]
  end
end
