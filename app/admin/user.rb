# frozen_string_literal: true
ActiveAdmin.register User do
  # Create sections on the index screen
  scope :all, default: true
  scope :admins
  scope :company_users
  scope :regular_users
  scope :needs_frilans_finans_id
  scope :managed_users

  filter :email
  filter :phone
  filter :first_name
  filter :last_name
  filter :ssn
  filter :language
  filter :company
  filter :frilans_finans_id
  filter :job_experience
  filter :education
  filter :competence_text
  filter :admin
  filter :cancelled
  filter :anonymized
  filter :managed

  index do
    column :id
    column :first_name
    column :last_name
    column :company
    column :frilans_finans_id
    column :current_status
    column :managed
    column :created_at

    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    f.input :password
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  permit_params do
    extras = [:password, :language_id, :company_id, :managed]
    UserPolicy::SELF_ATTRIBUTES + extras
  end
end
