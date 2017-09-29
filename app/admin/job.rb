# frozen_string_literal: true

ActiveAdmin.register Job do
  config.scoped_collection_actions_if = -> { true }

  menu parent: 'Jobs', priority: 1

  actions :all, except: [:destroy]
  batch_action :destroy, false

  scoped_collection_action :scoped_collection_update, title: I18n.t('admin.job.batch_action.update.title'), form: lambda { # rubocop:disable Metrics/LineLength
    yes_no = [[I18n.t('admin.yes_answer'), 't'], [I18n.t('admin.no_answer'), 'f']]
    {
      hidden: yes_no,
      featured: yes_no,
      filled: yes_no,
      cancelled: yes_no,
      upcoming: yes_no,
      just_arrived_contact_user_id: User.delivery_users.map do |user|
        [user.name, user.id]
      end
    }
  }

  # Create sections on the index screen
  scope :all, default: true
  scope :ongoing
  scope :unfilled
  scope :filled
  scope :cancelled
  scope :published

  # Filterable attributes on the index screen
  filter :near_address, label: I18n.t('admin.filter.near_address'), as: :string
  filter :translations_name_cont, as: :string, label: I18n.t('admin.job.name')
  filter :company, collection: -> { Company.order(:name) }
  filter :staffing_company_id_present, as: :select, collection: [['No', false]], label: 'Staffing job' # rubocop:disable Metrics/LineLength
  filter :job_date
  filter :job_end_date
  filter :just_arrived_contact_user, collection: -> { User.delivery_users }
  filter :created_at
  filter :featured
  filter :filled
  filter :staffing_company, collection: -> { Company.staffing_agencies.order(:name) }
  filter :direct_recruitment_job
  filter :upcoming
  filter :cancelled
  filter :hidden
  filter :skills, collection: -> { Skill.with_translations.order_by_name }
  filter :hourly_pay
  filter :translations_description_cont, as: :string, label: I18n.t('admin.job.description') # rubocop:disable Metrics/LineLength
  filter :publish_on_blocketjobb
  filter :publish_on_metrojobb
  filter :publish_on_linkedin

  # Customize columns displayed on the index screen in the table
  index do
    selectable_column

    column :id { |job| link_to(job.id, admin_job_path(job)) }
    column :applicants, sortable: 'job_users_count' do |job|
      column_content = safe_join([
                                   user_icon_png(html_class: 'table-column-icon'),
                                   job.job_users_count
                                 ])
      link_path = admin_job_users_path + AdminHelpers::Link.query(:job_id, job.id)

      link_to(column_content, link_path, class: 'table-column-icon-link')
    end
    column :original_name do |job|
      link_to(job.original_name, admin_job_path(job))
    end
    column :job_date do |job|
      european_date(job.job_date)
    end
    column :job_end_date do |job|
      european_date(job.job_end_date)
    end
    column :order_value do |job|
      order_value = job.order&.current_order_value
      if order_value
        NumberFormatter.new.to_delimited(
          order_value.sold_total_value,
          locale: :sv
        )
      end
    end
    column :city
    column :filled
    column :recruiter do |job|
      contact = job.just_arrived_contact
      link_to(contact.first_name, admin_user_path(contact)) if contact
    end
  end

  include AdminHelpers::MachineTranslation::Actions

  set_job_translation = lambda do |job, permitted_params|
    return unless job.persisted? && job.valid?

    translation_params = {
      name: permitted_params.dig(:job, :name),
      description: permitted_params.dig(:job, :description),
      short_description: permitted_params.dig(:job, :short_description),
      tasks_description: permitted_params.dig(:job, :tasks_description),
      applicant_description: permitted_params.dig(:job, :applicant_description),
      requirements_description: permitted_params.dig(:job, :requirements_description)
    }
    language = Language.find_by(id: permitted_params.dig(:job, :language_id))
    job.set_translation(translation_params, language)
  end

  after_save do |job|
    if job.persisted? && job.valid?
      set_job_translation.call(job, permitted_params)

      JobCancelledJob.perform_later(job: job) if job.cancelled_saved_to_true?
    end
  end

  member_action :create_job_with_order, method: :get do
    order_id = params[:order_id]
    order = Order.find_by(id: order_id)
    current_order_value = order&.current_order_value

    @job = Job.new(order_id: order_id)

    @job.company = order&.company
    @job.staffing_company_id = AppConfig.default_staffing_company_id if order&.staffing?
    @job.direct_recruitment_job = order&.direct_recruitment?

    hours_per_month = current_order_value&.sold_hours_per_month
    number_of_months = current_order_value&.sold_number_of_months

    if hours_per_month && number_of_months
      @job.hours = hours_per_month * number_of_months
    end

    render :new, layout: false
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

  action_item :create_arbetsformedlingen_ad, only: :show, if: -> { !resource.arbetsformedlingen_ad } do # rubocop:disable Metrics/LineLength
    link_to(
      I18n.t('admin.job.create_arbetsformedlingen_ad'),
      create_with_job_admin_arbetsformedlingen_ad_path(job_id: job.id)
    )
  end

  member_action :cancel_and_notify, method: :post do
    job = resource

    if job.update(cancelled: true)
      JobCancelledNotifier.call(job: job)
      message = I18n.t('admin.job.cancelled_and_notitied_success')

      redirect_to admin_job_path(job), notice: message
    else
      errors = job.errors.full_messages.join(', ')
      message = I18n.t('admin.job.cancelled_and_notitied_failed', errors: errors)

      redirect_to admin_job_path(job), alert: message
    end
  end

  action_item :cancel_and_notify, only: :show, if: -> { !resource.cancelled } do
    link_to(
      safe_join([envelope_icon_png, I18n.t('admin.job.cancel_and_notify_btn')]),
      cancel_and_notify_admin_job_path,
      method: :post
    )
  end

  sidebar :relations, only: %i(show edit) do
    render partial: 'admin/jobs/relations_list', locals: { job: job }
  end

  sidebar :data_checklist, only: %i(show edit) do
    div do
      safe_join(
        [
          strong(I18n.t('admin.job.checklist_sidebar.hidden')),
          status_tag(job.hidden)
        ]
      )
    end

    div do
      safe_join(
        [
          strong(I18n.t('admin.job.checklist_sidebar.published')),
          status_tag(job.published?)
        ]
      )
    end

    div do
      safe_join(
        [
          strong(I18n.t('admin.job.checklist_sidebar.preview_key')),
          status_tag(job.preview_key.presence)
        ]
      )
    end

    missing_translations = %w(en sv ar) - job.translations.map(&:locale).compact
    if missing_translations.any?
      h3 I18n.t('admin.job.checklist_sidebar.missing_translations')
      div do
        strong(
          missing_translations.join(', ')
        )
      end
    end

    hr

    h3 I18n.t('admin.job.checklist_sidebar.data_title')
    div do
      safe_join(
        [
          strong(I18n.t('admin.job.checklist_sidebar.skills')),
          status_tag(job.skills.any?)
        ]
      )
    end
    div do
      safe_join(
        [
          strong(I18n.t('admin.job.checklist_sidebar.languages')),
          status_tag(job.languages.any?)
        ]
      )
    end
    div do
      safe_join(
        [
          strong(I18n.t('admin.job.checklist_sidebar.occupations')),
          status_tag(job.occupations.any?)
        ]
      )
    end

    hr

    h3 I18n.t('admin.job.checklist_sidebar.pushed')
    div do
      safe_join([strong('Arbetsförmedlingen'), status_tag(job.arbetsformedlingen_ad.present?)]) # rubocop:disable Metrics/LineLength
    end
    div do
      safe_join([strong('LinkedIN'), status_tag(job.publish_on_linkedin)])
    end
    div do
      safe_join([strong('Blocketjobb'), status_tag(job.publish_on_blocketjobb)])
    end
    div do
      safe_join([strong('Metrojobb'), status_tag(job.publish_on_metrojobb)])
    end
  end

  sidebar :app, only: %i(show edit) do
    if job.preview_key.present?
      para link_to(
        I18n.t('admin.view_in_app.job_preview'),
        link_to_job_preview(job),
        target: '_blank'
      )

      strong('Copy-pastable link to customer: ')

      content_tag(:pre, link_to_job_preview(job, utm_medium: 'email'))
    else
      link_to(
        I18n.t('admin.view_in_app.job'),
        FrontendRouter.draw(:job, id: job.id, utm_medium: UTM_ADMIN_MEDIUM),
        target: '_blank'
      )
    end
  end

  sidebar :latest_applicants, only: %i(show edit) do
    ul do
      job.job_users.
        order(created_at: :desc).
        includes(:user).
        limit(50).each do |job_user|

        li link_to("##{job_user.id} " + job_user.user.name, admin_job_user_path(job_user))
      end
    end
  end

  form do |f|
    render partial: 'admin/jobs/form', locals: { f: f }
  end

  show do
    job_comments = job.comments.with_translations.includes(:owner)
    url = FrontendRouter.draw(:job, id: job.id, utm_medium: UTM_ADMIN_MEDIUM)
    locals = {
      job: job,
      job_comments: job_comments,
      frontend_app_job_path: url
    }
    render partial: 'admin/jobs/show', locals: locals
  end

  permit_params do
    extras = [
      :cancelled, :language_id, :hourly_pay_id, :category_id, :owner_user_id, :hidden,
      :company_contact_user_id, :just_arrived_contact_user_id, :municipality,
      :number_to_fill, :order_id, :full_time, :swedish_drivers_license, :car_required,
      :publish_on_linkedin, :publish_on_blocketjobb, :blocketjobb_category,
      :publish_on_metrojobb, :metrojobb_category,
      :salary_type, :preview_key, :customer_hourly_price, :invoice_comment,
      :staffing_company_id,
      job_skills_attributes: %i(skill_id proficiency proficiency_by_admin),
      job_languages_attributes: %i(language_id proficiency proficiency_by_admin),
      job_occupations_attributes: %i(occupation_id importance years_of_experience)
    ]
    JobPolicy::FULL_ATTRIBUTES + extras
  end

  controller do
    def scoped_collection
      super.with_translations.
        includes(:just_arrived_contact, order: %i(job_request)).
        left_joins(:job_users).
        select('jobs.*, count(job_users.id) as job_users_count').
        group('jobs.id, job_users.job_id')
    end

    def update_resource(job, params_array)
      job_params = params_array.first

      job_skills_attrs = job_params.delete(:job_skills_attributes)
      skill_ids_param = (job_skills_attrs&.to_unsafe_h || {}).map do |_index, attrs|
        {
          id: attrs[:skill_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetJobSkillsService.call(job: job, skill_ids_param: skill_ids_param)

      job_languages_attrs = job_params.delete(:job_languages_attributes)
      language_ids_param = (job_languages_attrs&.to_unsafe_h || {}).map do |_index, attrs|
        {
          id: attrs[:language_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetJobLanguagesService.call(job: job, language_ids_param: language_ids_param)

      job_occupations_attrs = job_params.delete(:job_occupations_attributes)
      occupation_ids_param = (job_occupations_attrs&.to_unsafe_h || {}).map do |_index, attrs| # rubocop:disable Metrics/LineLength
        {
          id: attrs[:occupation_id],
          years_of_experience: attrs[:years_of_experience],
          importance: attrs[:importance]
        }
      end
      SetJobOccupationsService.call(job: job, occupation_ids_param: occupation_ids_param)

      super
    end

    def apply_filtering(chain)
      @search = chain.ransack(params[:q] || {})
      @search.result(distinct: true)
    end
  end
end
