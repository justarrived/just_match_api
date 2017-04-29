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
      staffing_job: yes_no,
      direct_rectuitment_job: yes_no,
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

  # Filterable attributes on the index screen
  filter :near_address, label: I18n.t('admin.filter.near_address'), as: :string
  filter :translations_name_cont, as: :string, label: I18n.t('admin.job.name')
  filter :company, collection: -> { Company.order(:name) }
  filter :job_date
  filter :job_end_date
  filter :just_arrived_contact_user, collection: -> { User.delivery_users }
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
    column :hours
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
      short_description: permitted_params.dig(:job, :short_description)
    }
    language = Language.find_by(id: permitted_params.dig(:job, :language_id))
    job.set_translation(translation_params, language).tap do |result|
      ProcessTranslationJob.perform_later(
        translation: result.translation,
        changed: result.changed_fields
      )
    end
  end

  after_save do |job|
    set_job_translation.call(job, permitted_params)
  end

  member_action :create_job_with_order, method: :get do
    order_id = params[:order_id]
    @job = Job.new(order_id: order_id)

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
    job_comments = job.comments.with_translations.includes(:owner)
    locals = {
      job: job,
      job_comments: job_comments,
      frontend_app_job_path: FrontendRouter.draw(:job, id: job.id)
    }
    render partial: 'admin/jobs/show', locals: locals
  end

  permit_params do
    extras = [
      :cancelled, :language_id, :hourly_pay_id, :category_id, :owner_user_id, :hidden,
      :company_contact_user_id, :just_arrived_contact_user_id, :municipality,
      :number_to_fill, :order_id, :full_time, :swedish_drivers_license, :car_required,
      job_skills_attributes: [:skill_id, :proficiency, :proficiency_by_admin],
      job_languages_attributes: [:language_id, :proficiency, :proficiency_by_admin]
    ]
    JobPolicy::FULL_ATTRIBUTES + extras
  end

  controller do
    def scoped_collection
      super.with_translations.
        includes(:just_arrived_contact, skills: [:translations, :language]).
        left_joins(:job_users).
        select('jobs.*, count(job_users.id) as job_users_count').
        group('jobs.id, job_users.job_id')
    end

    def update_resource(job, params_array)
      job_params = params_array.first

      job_skills_attrs = job_params.delete(:job_skills_attributes)
      skill_ids_param = (job_skills_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:skill_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetJobSkillsService.call(job: job, skill_ids_param: skill_ids_param)

      job_languages_attrs = job_params.delete(:job_languages_attributes)
      language_ids_param = (job_languages_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:language_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetJobLanguagesService.call(job: job, language_ids_param: language_ids_param)
      super
    end

    def apply_filtering(chain)
      @search = chain.ransack(params[:q] || {})
      @search.result(distinct: true)
    end
  end
end
