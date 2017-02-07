# frozen_string_literal: true
ActiveAdmin.register User do
  menu parent: 'Users', priority: 1

  batch_action :destroy, false

  batch_action :send_communication_template_to, form: lambda {
    {
      type: %w[email sms both],
      template_id: CommunicationTemplate.to_form_array,
      job_id: Job.to_form_array(include_blank: true)
    }
  } do |ids, inputs|
    type = inputs['type']
    job = Job.with_translations.find_by(id: inputs['job_id'])
    template = CommunicationTemplate.with_translations.find(inputs['template_id'])

    data = {}
    if job
      job.attributes.symbolize_keys.each { |key, value| data[:"job_#{key}"] = value }
      data[:job_name] = job.name
      data[:job_description] = job.description
    end

    support_user = User.main_support_user
    response = MessageUsersFromTemplate.call(
      type: type,
      users: User.where(id: ids),
      template: template,
      data: data
    ) do |user, body, language_id|
      chat = Chat.find_or_create_private_chat([support_user, user])
      chat.create_message(author: support_user, body: body, language_id: language_id)
    end

    notice = response[:message]
    if response[:success]
      redirect_to collection_path, notice: notice
    else
      redirect_to collection_path, alert: notice
    end
  end

  batch_action :send_message_to, form: lambda {
    {
      type: %w[email sms both],
      language_id: Language.system_languages.to_form_array,
      subject:  :text,
      message:  :textarea
    }
  } do |ids, inputs|
    template = inputs['message']
    type = inputs['type']
    subject = inputs['subject']
    language_id = inputs['language_id']

    users = User.where(id: ids)
    support_user = User.main_support_user
    response = MessageUsers.call(
      type: type,
      users: users,
      template: template,
      subject: subject
    ) do |user, body|
      chat = Chat.find_or_create_private_chat([support_user, user])
      chat.create_message(author: support_user, body: body, language_id: language_id)
    end
    notice = response[:message]

    if response[:success]
      redirect_to collection_path, notice: notice
    else
      redirect_to collection_path, alert: notice
    end
  end

  batch_action :add_and_remove_user_tag, form: lambda {
    {
      remove_tag: Tag.to_form_array(include_blank: true),
      add_tag: Tag.to_form_array(include_blank: true)
    }
  } do |ids, inputs|
    add_tag = inputs['add_tag']
    remove_tag = inputs['remove_tag']

    if add_tag == remove_tag
      alert = I18n.t('admin.user.batch_form.tag_add_and_remove_not_uniq_notice')
      redirect_to collection_path, alert: alert
    else
      users = User.where(id: ids)
      notice = []

      unless add_tag.blank?
        tag = Tag.find_by(id: add_tag)
        users.each do |user|
          UserTag.safe_create(tag: tag, user: user)
        end
        notice << I18n.t('admin.user.batch_form.tag_added_notice', name: tag.name)
      end

      unless remove_tag.blank?
        tag = Tag.find_by(id: remove_tag)
        users.each do |user|
          UserTag.safe_destroy(tag: tag, user: user)
        end
        notice << I18n.t('admin.user.batch_form.tag_removed_notice', name: tag.name)
      end

      redirect_to collection_path, notice: notice.join(' ')
    end
  end

  batch_action :add_user_skill, form: lambda {
    {
      add_skill: Skill.to_form_array(include_blank: true),
      proficiency_by_admin: ['-', nil] + UserSkill::PROFICIENCY_RANGE.to_a
    }
  } do |ids, inputs|
    add_skill = inputs['add_skill']
    proficiency_by_admin = inputs['proficiency_by_admin']

    users = User.where(id: ids)
    notice = []

    unless add_skill.blank?
      skill = Skill.find_by(id: add_skill)
      users.each do |user|
        attributes = { skill: skill, user: user }
        unless proficiency_by_admin.blank?
          attributes[:proficiency_by_admin] = proficiency_by_admin
        end

        UserSkill.safe_create(**attributes)
      end
      notice << I18n.t('admin.user.batch_form.skill_added_notice', name: skill.name)
    end

    redirect_to collection_path, notice: notice.join(' ')
  end

  batch_action :verify, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |u| u.update(verified: true) }

    redirect_to collection_path, notice: I18n.t('admin.verified_selected')
  end

  batch_action :managed, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |u| u.update(managed: true) }

    redirect_to collection_path, notice: I18n.t('admin.user.managed_selected')
  end

  # Create sections on the index screen
  scope :all
  scope :admins
  scope :company_users
  scope :regular_users, default: true
  scope :needs_frilans_finans_id
  scope :managed_users
  scope :verified

  filter :by_near_address, label: I18n.t('admin.filter.near_address'), as: :string
  filter :first_name_or_last_name_cont, as: :string, label: I18n.t('admin.user.name')
  filter :interview_comment
  filter :tags
  # rubocop:disable Metrics/LineLength
  filter :skills, collection: -> { Skill.with_translations }
  filter :user_skills_proficiency_gteq, as: :select, collection: [nil, nil] + UserSkill::PROFICIENCY_RANGE.to_a
  filter :user_skills_proficiency_by_admin_gteq, as: :select, collection: [nil, nil] + UserSkill::PROFICIENCY_RANGE.to_a

  filter :interests, collection: -> { Interest.with_translations }
  filter :user_interests_level_gteq, as: :select, collection: [nil, nil] + UserInterest::LEVEL_RANGE.to_a
  filter :user_interests_level_by_admin_gteq, as: :select, collection: [nil, nil] + UserInterest::LEVEL_RANGE.to_a

  filter :languages, collection: -> { Language.order(:en_name) }
  filter :user_languages_proficiency_gteq, as: :select, collection: [nil, nil] + UserLanguage::PROFICIENCY_RANGE.to_a
  filter :user_languages_proficiency_by_admin_gteq, as: :select, collection: [nil, nil] + UserLanguage::PROFICIENCY_RANGE.to_a

  filter :created_at

  filter :translations_description_cont, as: :string, label: I18n.t('admin.user.description')
  filter :translations_education_cont, as: :string, label: I18n.t('admin.user.education')
  filter :translations_competence_text_cont, as: :string, label: I18n.t('admin.user.competence_text')
  filter :translations_job_experience_cont, as: :string, label: I18n.t('admin.user.job_experience')
  # rubocop:enable Metrics/LineLength
  filter :email
  filter :phone
  filter :frilans_finans_id
  filter :ssn

  index do
    selectable_column

    column :id
    column :name
    column :email
    column :city
    column :managed if params[:scope] == 'company_users'
    column(:tags) { |user| user_tag_badges(user: user) }

    actions
  end

  show do |user|
    columns do
      column do
        attributes_table do
          row :image do
            profile_image = user_profile_image(user: user, size: :small)

            image_tag(profile_image) if profile_image
          end
          row :name
          row :email
          row :phone
          row :skype_username
          row :street
          row :city
          row :zip
          row :ssn
        end

        h4 I18n.t('admin.user.show.interview_comment')
        div do
          simple_format(user.interview_comment)
        end

        div do
          content_tag(:p) do
            strong(
              [
                user.interviewed_at&.to_date, user.interviewed_by&.name
              ].compact.join(', ')
            )
          end
        end
      end

      if user.candidate?
        column do
          panel I18n.t('admin.user.show.candidate_summary') do
            h3 I18n.t('admin.user.show.city', city: user.city) unless user.city.blank?

            h3 I18n.t('admin.user.show.tags')
            div do
              content_tag(:p, user_tag_badges(user: user))
            end

            h3 I18n.t('admin.user.show.skills')
            div do
              content_tag(:p, user_skills_badges(user_skills: user.user_skills))
            end

            h3 I18n.t('admin.user.show.interests')
            div do
              content_tag(:p, user_interests_badges(user_interests: user.user_interests))
            end

            h3 I18n.t('admin.user.show.languages')
            div do
              content_tag(:p, user_languages_badges(user_languages: user.user_languages))
            end

            h3 I18n.t('admin.user.show.average_score', score: user.average_score || '-')

            h3 I18n.t('admin.user.show.verified', verified: user.verified)

            unless user.jobs.ongoing.empty?
              h3 I18n.t('admin.user.show.ongoing_jobs')
              table_for(user.jobs.ongoing) do
                column :name
                column :hours
                column :start { |job| european_date(job.job_date) }
                column :end { |job| european_date(job.job_end_date) }
              end
            end

            unless user.jobs.future.empty?
              h3 I18n.t('admin.user.show.future_jobs')
              table_for(user.jobs.future) do
                column :name
                column :hours
                column :start { |job| european_date(job.job_date) }
                column :end { |job| european_date(job.job_end_date) }
              end
            end
          end
        end
      end
    end

    if user.candidate?
      h3 I18n.t('admin.user.show.candidate_status')
      attributes_table do
        row :current_status
        row :at_und
        row :arrived_at
        row :country_of_origin
      end

      panel(I18n.t('admin.user.show.profile')) do
        div do
          h3 User.human_attribute_name(:description)
          div do
            simple_format(user.description)
          end
        end

        div do
          h3 User.human_attribute_name(:job_experience)
          div do
            simple_format(user.job_experience)
          end
        end

        div do
          h3 User.human_attribute_name(:competence_text)
          div do
            simple_format(user.competence_text)
          end
        end

        div do
          h3 User.human_attribute_name(:education)
          div do
            simple_format(user.education)
          end
        end
      end

    end

    columns do
      column do
        h3 I18n.t('admin.user.show.status_flags')
        attributes_table do
          row :super_admin
          row :admin
          row :managed
          row :anonymized
          row :banned
          row :verified
          row :just_arrived_staffing
        end
      end

      column do
        h3 I18n.t('admin.user.show.payment')
        attributes_table do
          row :account_clearing_number
          row :account_number
          row :frilans_finans_payment_details
        end
      end
    end

    support_chat = Chat.find_support_chat(user)
    if support_chat
      locals = { support_chat: support_chat }
      render partial: 'admin/chats/latest_messages', locals: locals
    end

    h3 I18n.t('admin.user.show.misc')
    attributes_table do
      row :ignored_notifications do
        user.ignored_notifications.join(', ')
      end

      row :id
      row :frilans_finans_id

      row :company
      row :language

      row :contact_email
      row :primary_role

      row :latitude
      row :longitude
      row :zip_latitude
      row :zip_longitude

      row :created_at { datetime_ago_in_words(user.created_at) }
      row :updated_at { datetime_ago_in_words(user.updated_at) }
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    if user.persisted?
      f.inputs I18n.t('admin.user.form.details') do
        f.input :email
        f.input :password, hint: I18n.t('admin.user.form.password.hint')
        f.input :first_name
        f.input :last_name
        f.input :language, hint: I18n.t('admin.user.form.language.hint')
        f.input :phone
        f.input :ssn
        f.input :street
        f.input :city
        f.input :zip
        f.input :skype_username
        f.input :description
      end

      f.inputs I18n.t('admin.user.form.competences') do
        f.has_many :user_tags, allow_destroy: true, new_record: true do |ff|
          ff.input :tag, as: :select, collection: Tag.all
        end

        f.has_many :user_interests, allow_destroy: false, new_record: true do |ff|
          ff.semantic_errors(*ff.object.errors.keys)

          ff.input :interest, as: :select, collection: Interest.with_translations
          ff.input :level_by_admin, as: :select, collection: UserInterest::LEVEL_RANGE
        end

        f.has_many :user_skills, allow_destroy: false, new_record: true do |ff|
          ff.semantic_errors(*ff.object.errors.keys)

          ff.input :skill, as: :select, collection: Skill.with_translations
          ff.input :proficiency_by_admin, as: :select, collection: UserSkill::PROFICIENCY_RANGE # rubocop:disable Metrics/LineLength
        end

        f.has_many :user_languages, allow_destroy: false, new_record: true do |ff|
          ff.semantic_errors(*ff.object.errors.keys)

          ff.input :language, as: :select, collection: Language.order(:en_name)
          ff.input :proficiency_by_admin, as: :select, collection: UserLanguage::PROFICIENCY_RANGE # rubocop:disable Metrics/LineLength
        end

        f.input :interview_comment
        f.input :job_experience
        f.input :education
        f.input :competence_text
      end

      f.inputs I18n.t('admin.user.form.immigration_status') do
        f.input :current_status
        f.input :at_und
        f.input :arrived_at
        f.input :country_of_origin
        f.input :arbetsformedlingen_registered_at
      end

      f.inputs I18n.t('admin.user.form.status_flags') do
        f.input :verified
        f.input :admin
        f.input :super_admin
        f.input :anonymized
        f.input :banned, hint: I18n.t('admin.user.form.banned.hint')
        f.input :managed, hint: I18n.t('admin.user.form.managed.hint')
        f.input :just_arrived_staffing, hint: I18n.t('admin.user.form.just_arrived_staffing.hint') # rubocop:disable Metrics/LineLength
      end

      f.inputs I18n.t('admin.user.form.payment_attributes') do
        f.input :account_clearing_number
        f.input :account_number
      end

      f.inputs I18n.t('admin.user.form.misc') do
        f.input :company
        f.input :next_of_kin_name
        f.input :next_of_kin_phone
        f.input :ignored_notifications, as: :select, collection: User::NOTIFICATIONS, multiple: true # rubocop:disable Metrics/LineLength
      end
    else
      f.inputs I18n.t('admin.user.form.create_user') do
        f.input :email
        f.input :password
        f.input :first_name
        f.input :last_name
        f.input :language
        f.input :company
        f.input :managed, hint: I18n.t('admin.user.form.managed.hint')
        f.input :phone
        f.input :ssn
        f.input :street
        f.input :city
        f.input :zip
        f.input :skype_username
      end
    end

    f.actions
  end

  include AdminHelpers::MachineTranslation::Actions

  member_action :sync_ff_bank_account, method: :patch do
    user = User.find(params[:id])

    if user.frilans_finans_id.nil?
      notice = I18n.t('admin.user.missing_ff_id')
      redirect_to(admin_user_path(user), alert: notice)
      return
    end

    unless user.bank_account_details?
      notice = I18n.t('admin.user.missing_account_details')
      redirect_to(admin_user_path(user), alert: notice)
      return
    end

    SyncFFUserAccountDetailsService.call(user: user)

    notice = I18n.t('admin.user.account_details_synced')
    redirect_to(admin_user_path(user), notice: notice)
  end

  action_item :view, only: :show do
    title = I18n.t('admin.user.sync_ff_bank_account')
    link_to title, sync_ff_bank_account_admin_user_path(user), method: :patch
  end

  sidebar :relations, only: [:show, :edit] do
    user_query = AdminHelpers::Link.query(:user_id, user.id)
    from_user_query = AdminHelpers::Link.query(:from_user_id, user.id)
    to_user_query = AdminHelpers::Link.query(:to_user_id, user.id)
    owner_user_query = AdminHelpers::Link.query(:owner_user_id, user.id)

    ul do
      if user.company?
        li(
          link_to(user.company.display_name, admin_company_path(user.company))
        )
      end
      li(
        link_to(
          I18n.t('admin.user.primary_language', lang: user.language.display_name),
          admin_language_path(user.language)
        )
      )
    end

    ul do
      if user.company?
        li(
          link_to(
            I18n.t('admin.counts.owned_jobs', count: user.owned_jobs.count),
            admin_jobs_path + owner_user_query
          )
        )
      else
        li(
          link_to(
            I18n.t('admin.counts.applications', count: user.job_users.count),
            admin_job_users_path + user_query
          )
        )
      end
      li(
        link_to(
          I18n.t('admin.counts.translations', count: user.translations.count),
          admin_user_translations_path + user_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.sessions', count: user.auth_tokens.count),
          admin_tokens_path + user_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.chats', count: user.chats.count),
          admin_chats_path + user_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.written_messages', count: user.messages.count),
          admin_messages_path + user_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.images', count: user.user_images.count),
          admin_user_images_path + user_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.received_ratings', count: user.received_ratings.count),
          admin_ratings_path + to_user_query
        )
      )
      li(
        link_to(
          I18n.t('admin.counts.given_ratings', count: user.given_ratings.count),
          admin_ratings_path + from_user_query
        )
      )
      li I18n.t('admin.counts.written_comments', count: user.written_comments.count)
    end
  end

  sidebar :latest_applications, only: [:show, :edit], if: proc { !user.company? } do
    ul do
      user.job_users.
        order(created_at: :desc).
        includes(job: [:translations]).
        limit(50).
        each do |job_user|

        li link_to("##{job_user.id} " + job_user.job.name, admin_job_user_path(job_user))
      end
    end
  end

  sidebar :latest_owned_jobs, only: [:show, :edit], if: proc { user.company? } do
    ul do
      user.owned_jobs.
        order(created_at: :desc).
        includes(:translations).
        limit(50).
        each do |job|

        li link_to("##{job.id} " + job.name, admin_job_path(job))
      end
    end
  end

  sidebar :profile_image, only: [:show, :edit] do
    profile_image = user_profile_image(user: user, size: :medium)
    image_tag(profile_image, class: 'sidebar-image') if profile_image
  end

  after_save do |user|
    if user.persisted?
      translation_params = {
        description: permitted_params.dig(:user, :description),
        job_experience: permitted_params.dig(:user, :job_experience),
        education: permitted_params.dig(:user, :education),
        competence_text: permitted_params.dig(:user, :competence_text)
      }
      user.set_translation(translation_params)
      SyncFrilansFinansUserJob.perform_later(user: user)
    end
  end

  permit_params do
    extras = [
      :password, :language_id, :company_id, :managed, :frilans_finans_payment_details,
      :verified, :interview_comment, :banned, :just_arrived_staffing,
      :language_ids, :skill_ids, ignored_notifications: []
    ]
    extras << :super_admin if authenticated_admin_user.super_admin?

    relations = [
      user_skills_attributes: [:skill_id, :proficiency, :proficiency_by_admin],
      user_languages_attributes: [:language_id, :proficiency, :proficiency_by_admin],
      user_interests_attributes: [:interest_id, :level, :level_by_admin],
      user_tags_attributes: [:id, :tag_id, :_destroy]
    ]
    UserPolicy::SELF_ATTRIBUTES + extras + relations
  end

  controller do
    def scoped_collection
      super.includes(:tags)
    end

    def update_resource(user, params_array)
      user_params = params_array.first

      user_interests_attrs = user_params.delete(:user_interests_attributes)
      interest_ids_param = (user_interests_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:interest_id],
          level: attrs[:level],
          level_by_admin: attrs[:level_by_admin]
        }
      end
      SetUserInterestsService.call(user: user, interest_ids_param: interest_ids_param)

      user_skills_attrs = user_params.delete(:user_skills_attributes)
      skill_ids_param = (user_skills_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:skill_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetUserSkillsService.call(user: user, skill_ids_param: skill_ids_param)

      user_languages_attrs = user_params.delete(:user_languages_attributes)
      language_ids_param = (user_languages_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:language_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end

      SetUserLanguagesService.call(user: user, language_ids_param: language_ids_param)
      super
    end

    def find_resource
      User.includes(
        user_skills: [:skill],
        user_languages: [:language],
        user_interests: [:interest],
        interests: [:translations, :language],
        skills: [:translations, :language]
      ).
        where(id: params[:id]).
        first!
    end
  end
end
