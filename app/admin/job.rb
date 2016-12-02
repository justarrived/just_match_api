# frozen_string_literal: true
ActiveAdmin.register Job do
  menu parent: 'Jobs', priority: 1

  batch_action :destroy, false

  # Create sections on the index screen
  scope :all, default: true
  scope :featured
  scope :visible
  scope :uncancelled
  scope :cancelled
  scope :filled
  scope :unfilled

  # Filterable attributes on the index screen
  filter :name
  filter :company
  filter :job_date
  filter :job_end_date
  filter :created_at
  filter :featured
  filter :filled
  filter :upcoming
  filter :cancelled
  filter :hidden
  filter :hourly_pay

  # Customize columns displayed on the index screen in the table
  index do
    selectable_column

    column :id
    column :original_name
    column :job_date
    column :job_end_date
    column :hours
    column :featured
    column :filled
    column :upcoming
    column :hidden

    actions
  end

  include AdminHelpers::MachineTranslation::Actions

  after_save do |job|
    translation_params = {
      name: permitted_params.dig(:job, :name),
      description: permitted_params.dig(:job, :description),
      short_description: permitted_params.dig(:job, :short_description)
    }
    job.set_translation(translation_params)
  end

  action_item :view, only: :show do
    title = I18n.t('admin.job.google_calendar_link')
    link_to title, resource.google_calendar_template_url
  end

  member_action :clone, method: :get do
    base_job = Job.find(params[:id])
    @job = base_job.dup

    Job.translated_fields.each do |translated_field|
      text = base_job.public_send(translated_field)
      @job.public_send("#{translated_field}=", text)
      # NOTE: We can't use the regular #field= method, since the active admin
      #  form will access the attribute using the #[] method
      @job[translated_field] = text
    end

    render :new, layout: false
  end

  action_item only: :show do
    link_to('Clone', clone_admin_job_path(id: job.id))
  end

  sidebar :applicants, only: :show do
    ul do
      li link_to "Has #{job.job_users.count} applicants", admin_job_users_path + "?q[job_id_eq]=#{job.id}" # rubocop:disable Metrics/LineLength
      li link_to 'View applicants', admin_job_users_path + "?q[job_id_eq]=#{job.id}"
    end
  end

  sidebar :comments, only: :show do
    ul do
      li "Has #{job.comments.count} comments"
    end
  end

  sidebar :app, only: :show do
    ul do
      li link_to 'View in app', FrontendRouter.draw(:job, id: job.id), target: '_blank'
      li link_to 'View candiates in app', FrontendRouter.draw(:job_users, job_id: job.id), target: '_blank' # rubocop:disable Metrics/LineLength
    end
  end

  permit_params do
    extras = [
      :cancelled, :language_id, :hourly_pay_id, :category_id, :owner_user_id, :hidden
    ]
    JobPolicy::FULL_ATTRIBUTES + extras
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
