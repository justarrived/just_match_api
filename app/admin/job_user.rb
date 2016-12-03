# frozen_string_literal: true
ActiveAdmin.register JobUser do
  menu parent: 'Jobs'

  batch_action :destroy, false

  scope :all, default: true
  scope :accepted
  scope :will_perform

  filter :user
  filter :job
  filter :frilans_finans_invoice
  filter :invoice
  filter :updated_at
  filter :created_at

  index do
    selectable_column

    column :id
    column :user
    column :job
    column :accepted
    column :will_perform
    column :performed
    column :frilans_finans_invoice
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :frilans_finans_invoice
      row :invoice
      row :user
      row :job

      row :accepted
      row :will_perform
      row :performed
      row :accepted_at

      row :apply_message
      row :language

      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  include AdminHelpers::MachineTranslation::Actions

  after_save do |job_user|
    translation_params = {
      name: permitted_params.dig(:job_user, :apply_message)
    }
    job_user.set_translation(translation_params)
  end

  sidebar :app, only: :show do
    ul do
      li link_to I18n.t('admin.view_in_app.candidates'), FrontendRouter.draw(:job_user_for_company, job_id: job_user.job_id, job_user_id: job_user.id), target: '_blank' # rubocop:disable Metrics/LineLength
    end
  end

  permit_params do
    [:accepted, :will_perform, :performed, :apply_message]
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
