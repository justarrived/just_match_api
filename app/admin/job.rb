# frozen_string_literal: true
ActiveAdmin.register Job do
  menu parent: 'Jobs', priority: 1

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
  filter :by_near_address, label: I18n.t('admin.filter.near_address'), as: :string
  filter :translations_name_cont, as: :string, label: I18n.t('admin.job.name')
  filter :company
  filter :job_date
  filter :job_end_date
  filter :created_at
  filter :featured
  filter :filled
  filter :upcoming
  filter :cancelled
  filter :hidden
  filter :skills, collection: -> { Skill.with_translations }
  filter :hourly_pay
  filter :translations_description_cont, as: :string, label: I18n.t('admin.job.description') # rubocop:disable Metrics/LineLength
  filter :translations_short_description_cont, as: :string, label: I18n.t('admin.job.short_description') # rubocop:disable Metrics/LineLength

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
    job.set_translation(translation_params).tap do |result|
      EnqueueCheapTranslation.call(result)
    end
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
    job_query = AdminHelpers::Link.query(:job_id, job.id)

    ul do
      li link_to job.company.display_name, admin_company_path(job.company)
      li link_to job.owner.display_name, admin_user_path(job.owner)
    end

    ul do
      li(
        link_to(
          I18n.t('admin.counts.applicants', count: job.job_users.count),
          admin_job_users_path + job_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.translations', count: job.translations.count),
          admin_job_translations_path + job_query
        )
      )
      li I18n.t('admin.counts.comments', count: job.comments.count)
    end
  end

  sidebar :app, only: [:show, :edit] do
    ul do
      # rubocop:disable Metrics/LineLength
      li link_to I18n.t('admin.view_in_app.view'), FrontendRouter.draw(:job, id: job.id), target: '_blank'
      li link_to I18n.t('admin.view_in_app.candidates'), FrontendRouter.draw(:job_users, job_id: job.id), target: '_blank'
      # rubocop:enable Metrics/LineLength
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
    h3 I18n.t('admin.job.show.general')
    attributes_table do
      row :id
      row :filled
      row :name
      row :hours
      row :gross_amount { |job| "#{job.gross_amount} SEK" }
      row :job_date
      row :job_end_date
      row :hourly_pay
      row :short_description
      row :street
      row :zip
      row :description { |job| simple_format(job.description) }
    end

    h3 I18n.t('admin.job.show.status_flags')
    attributes_table do
      row :featured
      row :verified
      row :upcoming
      row :cancelled
      row :hidden
    end

    h3 I18n.t('admin.job.show.relations')
    attributes_table do
      row :owner
      row :company_contact
      row :just_arrived_contact
      row :category
      row :language
    end

    h3 I18n.t('admin.job.show.misc')
    attributes_table do
      row :latitude
      row :longitude
      row :zip_latitude
      row :zip_longitude

      row :created_at { datetime_ago_in_words(job.created_at) }
      row :updated_at { datetime_ago_in_words(job.updated_at) }
    end
    active_admin_comments
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
      super.with_translations
    end
  end
end
