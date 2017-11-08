# frozen_string_literal: true

ActiveAdmin.register User do
  menu parent: 'Users', priority: 1

  actions :all, except: [:destroy]
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

      if add_tag.present?
        tag = Tag.find_by(id: add_tag)
        users.each do |user|
          UserTag.safe_create(tag: tag, user: user)
        end
        notice << I18n.t('admin.user.batch_form.tag_added_notice', name: tag.name)
      end

      if remove_tag.present?
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

    if add_skill.present?
      skill = Skill.find_by(id: add_skill)
      users.each do |user|
        attributes = { skill: skill, user: user }
        if proficiency_by_admin.present?
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

  member_action :find_frilans_finans_user, method: :post do
    user = resource

    if user.frilans_finans_id.present?
      notice = I18n.t(
        'admin.user.find_ff_user.ff_id_present_msg', id: user.frilans_finans_id
      )
      redirect_to admin_user_path(user), alert: notice
    else
      remote_id = FindFrilansFinansUserIdService.call(email: user.email)

      if remote_id.present?
        user.frilans_finans_id = remote_id
        user.save!

        notice = I18n.t('admin.user.find_ff_user.ff_id_found_msg', id: remote_id)
        redirect_to admin_user_path(user), notice: notice
      else
        notice = I18n.t('admin.user.find_ff_user.ff_id_not_found_msg')
        redirect_to admin_user_path(user), alert: notice
      end
    end
  end

  action_item :find_frilans_finans_user, only: :show, if: proc { resource.frilans_finans_id.blank? } do # rubocop:disable Metrics/LineLength
    link_to(
      I18n.t('admin.user.find_ff_user.find_button'),
      find_frilans_finans_user_admin_user_path(id: user.id),
      method: :post
    )
  end

  action_item :push_frilans_finans, only: :show do
    link_to(
      I18n.t('admin.user.push_frilans_finans_btn'),
      push_frilans_finans_admin_user_path(id: user.id),
      method: :post
    )
  end

  member_action :push_frilans_finans, method: :post do
    user = resource

    document = SyncFrilansFinansUserService.call(user: user)
    if document.error_status?
      message = I18n.t('admin.user.push_ff_user_failed', status: document.status)
      redirect_to admin_user_path(user), alert: message
    else
      message = I18n.t('admin.user.push_ff_user_success', status: document.status)
      redirect_to admin_user_path(user), notice: message
    end
  end

  # Create sections on the index screen
  scope :all
  scope :admins
  scope :company_users
  scope :regular_users, default: true
  scope :needs_frilans_finans_id
  scope :managed_users
  scope :verified

  # rubocop:disable Metrics/LineLength
  filter :near_address, label: I18n.t('admin.filter.near_address'), as: :string
  filter :first_name_or_last_name_cont, as: :string, label: I18n.t('admin.user.name')
  filter :documents_text_content_cont, as: :string, label: I18n.t('admin.user.resume_search_label')
  filter :interview_comment
  filter :tags, collection: -> { Tag.order(:name) }
  filter :skills, collection: -> { Skill.with_translations.order_by_name }
  filter :user_skills_proficiency_gteq, as: :select, collection: [nil, nil] + UserSkill::PROFICIENCY_RANGE.to_a
  filter :user_skills_proficiency_by_admin_gteq, as: :select, collection: [nil, nil] + UserSkill::PROFICIENCY_RANGE.to_a

  filter :interests, collection: -> { Interest.with_translations.order_by_name }
  filter :user_interests_level_gteq, as: :select, collection: [nil, nil] + UserInterest::LEVEL_RANGE.to_a
  filter :user_interests_level_by_admin_gteq, as: :select, collection: [nil, nil] + UserInterest::LEVEL_RANGE.to_a

  filter :system_language, collection: -> { Language.system_languages.order(:en_name) }, label: I18n.t('admin.user.system_language')
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
  filter :id
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
    support_chat = Chat.includes(messages: %i(translations author language)).
                   find_or_create_support_chat(user)
    render partial: 'admin/users/show', locals: { support_chat: support_chat }
  end

  form do |f|
    render partial: 'admin/users/form', locals: { f: f }
  end

  include AdminHelpers::MachineTranslation::Actions

  sidebar :relations, only: %i(show edit) do
    render partial: 'admin/users/relations_list', locals: { user: user }
  end

  sidebar :latest_applications, only: %i(show edit), if: proc { !user.company? } do
    ul do
      user.job_users.includes(job: %i[translations language]).recent(50).each do |job_user| # rubocop:disable Metrics/LineLength
        li link_to("##{job_user.id} #{job_user.job.name}", admin_job_user_path(job_user))
      end
    end
  end

  sidebar :latest_owned_jobs, only: %i(show edit), if: proc { user.company? } do
    ul do
      user.owned_jobs.
        order(created_at: :desc).
        with_translations.
        limit(50).
        each do |job|

        li link_to("##{job.id} " + job.name, admin_job_path(job))
      end
    end
  end

  sidebar :profile_image, only: %i(show edit) do
    profile_image = user_profile_image(user: user, size: :medium)
    image_tag(profile_image, class: 'sidebar-image') if profile_image
  end

  sidebar :documents, only: %i(show edit) do
    user_documents = user.user_documents.recent(50).includes(:document)

    locals = { user_documents: user_documents }
    render partial: 'admin/users/documents_list', locals: locals
  end

  sidebar :latest_activity, only: %i[show edit] do
    render partial: 'admin/users/latest_activity', locals: { user: user }
  end

  set_user_translation = lambda do |user, permitted_params|
    return unless user.persisted? && user.valid?

    translation_params = {
      description: permitted_params.dig(:user, :description),
      job_experience: permitted_params.dig(:user, :job_experience),
      education: permitted_params.dig(:user, :education),
      competence_text: permitted_params.dig(:user, :competence_text)
    }
    user.set_translation(translation_params).tap do |result|
      ProcessTranslationJob.perform_later(
        translation: result.translation,
        changed: result.changed_fields
      )
    end
  end

  after_save do |user|
    set_user_translation.call(user, permitted_params)
    if AppConfig.frilans_finans_active? && user.valid?
      SyncFrilansFinansUserJob.perform_later(user: user)
    end
  end

  permit_params do
    extras = [
      :password, :language_id, :company_id, :managed, :frilans_finans_payment_details,
      :verified, :interview_comment, :banned, :just_arrived_staffing,
      :presentation_profile, :presentation_personality, :presentation_availability,
      :language_ids, :skill_ids, ignored_notifications: []
    ]
    extras << :super_admin if authenticated_admin_user.super_admin?

    relations = [
      user_skills_attributes: %i(skill_id proficiency proficiency_by_admin),
      user_languages_attributes: %i(language_id proficiency proficiency_by_admin),
      user_interests_attributes: %i(interest_id level level_by_admin),
      user_tags_attributes: %i(id tag_id _destroy),
      user_documents_attributes: [:id, :category, { document_attributes: [:document] }],
      feedbacks_attributes: %i(id job_id title body)
    ]
    UserPolicy::SELF_ATTRIBUTES + extras + relations
  end

  controller do
    def scoped_collection
      super.includes(:tags)
    end

    def update_resource(user, params_array)
      user_params = params_array.first

      document_params = user_params[:user_documents_attributes]&.to_unsafe_h
      if document_params
        new_document_params = {}
        document_params.each do |key, attributes|
          # We don't want to touch already created user documents
          new_document_params[key] = attributes unless attributes['id']
        end
        user_params[:user_documents_attributes] = new_document_params
      end

      user_interests_attrs = user_params.delete(:user_interests_attributes)
      interest_ids_param = (user_interests_attrs&.to_unsafe_h || {}).map do |_index, attrs| # rubocop:disable Metrics/LineLength
        {
          id: attrs[:interest_id],
          level: attrs[:level],
          level_by_admin: attrs[:level_by_admin]
        }
      end
      SetUserInterestsService.call(user: user, interest_ids_param: interest_ids_param)

      user_skills_attrs = user_params.delete(:user_skills_attributes)
      skill_ids_param = (user_skills_attrs&.to_unsafe_h || {}).map do |_index, attrs|
        {
          id: attrs[:skill_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetUserSkillsService.call(user: user, skill_ids_param: skill_ids_param)

      user_languages_attrs = user_params.delete(:user_languages_attributes)
      language_ids_param = (user_languages_attrs&.to_unsafe_h || {}).map do |_index, attrs| # rubocop:disable Metrics/LineLength
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
        jobs: %i(translations language),
        user_documents: %i(document),
        user_skills: %i(skill),
        user_languages: %i(language),
        user_interests: %i(interest),
        interests: %i(translations language),
        skills: %i(translations language)
      ).
        where(id: params[:id]).
        first!
    end
  end
end
