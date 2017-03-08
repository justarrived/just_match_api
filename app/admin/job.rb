# frozen_string_literal: true
ActiveAdmin.register Job do
  menu parent: 'Jobs', priority: 1

  actions :all, except: [:destroy]
  batch_action :destroy, false

  batch_action :filled, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |j| j.update(filled: true) }

    redirect_to collection_path, notice: I18n.t('admin.job.filled_selected')
  end

  batch_action :upcoming, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |j| j.update(upcoming: true) }

    redirect_to collection_path, notice: I18n.t('admin.job.upcoming_selected')
  end

  batch_action :hidden, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |j| j.update(hidden: true) }

    redirect_to collection_path, notice: I18n.t('admin.job.hidden_selected')
  end

  batch_action :verify, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |j| j.update(verified: true) }

    redirect_to collection_path, notice: I18n.t('admin.verified_selected')
  end

  # Create sections on the index screen
  scope :all, default: true
  scope :ongoing
  scope :featured
  scope :visible
  scope :uncancelled
  scope :cancelled
  scope :filled
  scope :unfilled

  # Filterable attributes on the index screen
  filter :near_address, label: I18n.t('admin.filter.near_address'), as: :string
  filter :translations_name_cont, as: :string, label: I18n.t('admin.job.name')
  filter :company, collection: -> { Company.order(:name) }
  filter :job_date
  filter :job_end_date
  filter :created_at
  filter :featured
  filter :filled
  filter :upcoming
  filter :cancelled
  filter :hidden
  filter :skills, collection: -> { Skill.with_translations.order_by_name }
  filter :hourly_pay
  filter :translations_description_cont, as: :string, label: I18n.t('admin.job.description') # rubocop:disable Metrics/LineLength
  filter :translations_short_description_cont, as: :string, label: I18n.t('admin.job.short_description') # rubocop:disable Metrics/LineLength

  # Customize columns displayed on the index screen in the table
  index do
    selectable_column

    column :id
    column :applicants, sortable: 'job_users_count', &:job_users_count
    column :original_name do |job|
      link_to(job.original_name, admin_job_path(job))
    end
    column :job_date do |job|
      job.job_date.strftime('%Y-%m-%d')
    end
    column :job_end_date do |job|
      job.job_end_date.strftime('%Y-%m-%d')
    end
    column :hours
    column :city
    column :filled
    column :recruiter do |job|
      contact = job.just_arrived_contact
      link_to(contact.first_name, admin_user_path(contact)) if contact
    end
  end

  include AdminHelpers::MachineTranslation::Actions

  SET_JOB_TRANSLATION = lambda do |job, permitted_params|
    return unless job.persisted? && job.valid?

    translation_params = {
      name: permitted_params.dig(:job, :name),
      description: permitted_params.dig(:job, :description),
      short_description: permitted_params.dig(:job, :short_description)
    }
    job.set_translation(translation_params).tap do |result|
      EnqueueCheapTranslation.call(result)
    end
  end

  after_create do |job|
    SET_JOB_TRANSLATION.call(job, permitted_params)
  end

  after_save do |job|
    SET_JOB_TRANSLATION.call(job, permitted_params)
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

  action_item :clone, only: :show do
    link_to(I18n.t('admin.job.clone'), clone_admin_job_path(id: job.id))
  end

  sidebar :relations, only: [:show, :edit] do
    render partial: 'admin/jobs/relations_list', locals: { job: job }
  end

  form do |f|
    render partial: 'admin/jobs/form', locals: { f: f }
  end

  sidebar :app, only: [:show, :edit] do
    ul do
      li link_to(
        I18n.t('admin.view_in_app.job'),
        FrontendRouter.draw(:job, id: job.id),
        target: '_blank'
      )
    end
  end

  sidebar :latest_applicants, only: [:show, :edit] do
    ul do
      job.job_users.
        order(created_at: :desc).
        includes(:user).
        limit(50).each do |job_user|

        li link_to("##{job_user.id} " + job_user.user.name, admin_job_user_path(job_user))
      end
    end
  end

  show do
    render partial: 'admin/jobs/show', locals: { job: job }
  end

  permit_params do
    extras = [
      :cancelled, :language_id, :hourly_pay_id, :category_id, :owner_user_id, :hidden,
      :company_contact_user_id, :just_arrived_contact_user_id
    ]
    JobPolicy::FULL_ATTRIBUTES + extras
  end

  controller do
    def scoped_collection
      super.with_translations.
        includes(:just_arrived_contact).
        joins(:job_users).
        select('jobs.*, count(job_users.id) as job_users_count').
        group('jobs.id, job_users.job_id')
    end

    def apply_filtering(chain)
      @search = chain.ransack(params[:q] || {})
      @search.result(distinct: true)
    end
  end
end
