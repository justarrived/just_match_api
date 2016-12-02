# frozen_string_literal: true
ActiveAdmin.register User do
  menu parent: 'Users', priority: 1

  batch_action :destroy, false

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
    selectable_column

    column :id
    column :first_name
    column :last_name
    column :email
    column :company
    column :frilans_finans_id
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

  include AdminHelpers::MachineTranslation::Actions

  after_save do |user|
    translation_params = {
      description: permitted_params.dig(:user, :description),
      job_experience: permitted_params.dig(:user, :job_experience),
      education: permitted_params.dig(:user, :education),
      competence_text: permitted_params.dig(:user, :competence_text)
    }
    user.set_translation(translation_params)
  end

  permit_params do
    extras = [
      :password, :language_id, :company_id, :managed, :frilans_finans_payment_details,
      :verified
    ]
    UserPolicy::SELF_ATTRIBUTES + extras
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
