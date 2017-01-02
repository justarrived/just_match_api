# frozen_string_literal: true
ActiveAdmin.register User do
  menu parent: 'Users', priority: 1

  batch_action :destroy, false

  batch_action :send_message_to, form: {
    type: %w[sms email both],
    subject:  :text,
    message:  :textarea
  } do |ids, inputs|
    template = inputs['message']
    type = inputs['type']
    subject = inputs['subject']

    users = User.where(id: ids)
    response = MessageUsers.call(
      type: type,
      users: users,
      template: template,
      subject: subject
    )
    notice = response[:message]

    if response[:success]
      redirect_to collection_path, notice: notice
    else
      redirect_to collection_path, alert: notice
    end
  end

  batch_action :add_and_remove_tag, form: {
    # NOTE: Tag's will be loaded when the code is, instead of on each request.
    # Server restart required to get an update list of tags
    remove_tag: Tag.to_form_array(include_blank: true),
    add_tag: Tag.to_form_array(include_blank: true)
  } do |ids, inputs|
    add_tag = inputs['add_tag']
    remove_tag = inputs['remove_tag']

    users = User.where(id: ids)
    notice = []

    unless add_tag.blank?
      tag = Tag.find_by(id: add_tag)
      UserTag.safe_create(tag: tag, users: users)
      notice << I18n.t('admin.user.batch_form.tag_added_notice', name: tag.name)
    end

    unless remove_tag.blank?
      tag = Tag.find_by(id: remove_tag)
      UserTag.safe_destroy(tag: tag, users: users)
      notice << I18n.t('admin.user.batch_form.tag_removed_notice', name: tag.name)
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
  filter :email
  filter :verified
  filter :phone
  filter :ssn
  filter :tags
  filter :language
  filter :company
  filter :frilans_finans_id
  filter :job_experience
  filter :education
  filter :competence_text
  filter :admin
  filter :anonymized
  filter :managed
  filter :created_at
  # rubocop:disable Metrics/LineLength
  filter :translations_description_cont, as: :string, label: I18n.t('admin.user.description')
  filter :translations_education_cont, as: :string, label: I18n.t('admin.user.education')
  filter :translations_competence_text_cont, as: :string, label: I18n.t('admin.user.competence_text')
  filter :translations_job_experience_cont, as: :string, label: I18n.t('admin.user.job_experience')
  # rubocop:enable Metrics/LineLength

  index do
    selectable_column

    column :id
    column :name
    column :email

    actions
  end

  show do |user|
    h3 I18n.t('admin.user.show.general')
    attributes_table do
      row :id
      row :frilans_finans_id
      row :verified
      row :average_score

      row :name
      row :email
      row :phone
      row :skype_username
      row :street
      row :zip
      row :ssn
      row :company
      row :language
      row :tags do
        tag_links = user.tags.map { |tag| link_to tag.name, admin_tag_path(tag) }
        safe_join(tag_links, ', ')
      end
    end

    unless user.company?
      h3 I18n.t('admin.user.show.profile')
      attributes_table do
        row :current_status
        row :at_und
        row :arrived_at
        row :description
        row :job_experience
        row :competence_text
        row :education
        row :country_of_origin
      end

      h3 I18n.t('admin.user.show.payment')
      attributes_table do
        row :frilans_finans_payment_details
        row :account_clearing_number
        row :account_number
      end
    end

    h3 I18n.t('admin.user.show.status_flags')
    attributes_table do
      row :admin
      row :managed
      row :anonymized
      row :banned
    end

    h3 I18n.t('admin.user.show.misc')
    attributes_table do
      row :ignored_notifications do
        user.ignored_notifications.join(', ')
      end

      row :contact_email
      row :primary_role

      row :latitude
      row :longitude
      row :zip_latitude
      row :zip_longitude

      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    f.input :password
    f.actions         # adds the 'Submit' and 'Cancel' buttons
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

  sidebar :relations, only: :show do
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

  sidebar :latest_applications, only: :show, if: proc { !user.company? } do
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

  sidebar :latest_owned_jobs, only: :show, if: proc { user.company? } do
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
