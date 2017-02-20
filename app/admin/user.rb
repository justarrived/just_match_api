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
    job_id = inputs['job_id']
    template_id = inputs['template_id']

    users = User.where(id: ids)
    job = Job.with_translations.find_by(id: job_id)
    template = CommunicationTemplate.with_translations.find(template_id)

    response = SendAdminCommunicationTemplate.call(
      users: users,
      job: job,
      communcation_template: template,
      type: type
    )

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
    response = SendAdminMessage.call(
      users: User.where(id: ids),
      type: inputs['type'],
      subject: inputs['subject'],
      template: inputs['message'],
      language_id: inputs['language_id']
    )
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
  filter :tags, collection: -> { Tag.order(:name) }
  # rubocop:disable Metrics/LineLength
  filter :skills, collection: -> { Skill.with_translations.order_by_name }
  filter :user_skills_proficiency_gteq, as: :select, collection: [nil, nil] + UserSkill::PROFICIENCY_RANGE.to_a
  filter :user_skills_proficiency_by_admin_gteq, as: :select, collection: [nil, nil] + UserSkill::PROFICIENCY_RANGE.to_a

  filter :interests, collection: -> { Interest.with_translations.order_by_name }
  filter :user_interests_level_gteq, as: :select, collection: [nil, nil] + UserInterest::LEVEL_RANGE.to_a
  filter :user_interests_level_by_admin_gteq, as: :select, collection: [nil, nil] + UserInterest::LEVEL_RANGE.to_a

  filter :languages, collection: -> { Language.order(:en_name) }
  filter :user_languages_proficiency_gteq, as: :select, collection: [nil, nil] + UserLanguage::PROFICIENCY_RANGE.to_a
  filter :user_languages_proficiency_by_admin_gteq, as: :select, collection: [nil, nil] + UserLanguage::PROFICIENCY_RANGE.to_a

  filter :created_at
  filter :gender

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
    support_chat = Chat.includes(messages: [:translations, :author, :language]).
                   find_support_chat(user)
    render partial: 'admin/users/show', locals: { support_chat: support_chat }
  end

  form do |f|
    render partial: 'admin/users/form', locals: { f: f }
  end

  include AdminHelpers::MachineTranslation::Actions

  sidebar :relations, only: [:show, :edit] do
    render partial: 'admin/users/relations_list', locals: { user: user }
  end

  sidebar :latest_applications, only: [:show, :edit], if: proc { !user.company? } do
    ul do
      user.job_users.includes(job: [:translations]).recent(50).each do |job_user|
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

  sidebar :documents, only: [:show, :edit] do
    user_documents = user.user_documents.recent(50).includes(:document)

    locals = { user_documents: user_documents }
    render partial: 'admin/users/documents_list', locals: locals
  end

  SET_USER_TRANSLATION = lambda do |user, permitted_params|
    return unless user.persisted? && user.valid?

    translation_params = {
      description: permitted_params.dig(:user, :description),
      job_experience: permitted_params.dig(:user, :job_experience),
      education: permitted_params.dig(:user, :education),
      competence_text: permitted_params.dig(:user, :competence_text)
    }
    user.set_translation(translation_params).tap do |result|
      EnqueueCheapTranslation.call(result)
    end
  end

  after_create do |user|
    SET_USER_TRANSLATION.call(user, permitted_params)
  end

  after_save do |user|
    SET_USER_TRANSLATION.call(user, permitted_params)
    if AppConfig.frilans_finans_active? && user.persisted? && user.valid?
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
