# frozen_string_literal: true
ActiveAdmin.register JobUser do
  menu parent: 'Jobs', priority: 2

  batch_action :destroy, false

  scope :all, default: true
  scope :accepted
  scope :will_perform
  scope :verified

  filter :user_verified_eq, as: :boolean, label: I18n.t('admin.user.verified')
  filter :job, collection: -> { Job.with_translations.last(200) }
  filter :frilans_finans_invoice
  filter :invoice
  filter :accepted
  filter :will_perform
  filter :performed
  filter :updated_at
  filter :created_at
  filter :translations_apply_message_cont, as: :string, label: I18n.t('admin.job_user.apply_message') # rubocop:disable Metrics/LineLength

  index do
    selectable_column

    column :id
    column :user
    column :job
    column :job_start_date { |job_user| job_user.job.job_date }
    column :user_city { |job_user| job_user.user.city }
    column :status, &:current_status

    actions
  end

  show do
    if job_user.job.ended?
      render partial: 'job_ended_view', locals: { job_user: job_user }
    else
      render partial: 'show', locals: { job_user: job_user }
    end

    support_chat = Chat.find_support_chat(job_user.user)
    if support_chat
      locals = { support_chat: support_chat }
      render partial: 'admin/chats/latest_messages', locals: locals
    end

    active_admin_comments
  end

  include AdminHelpers::MachineTranslation::Actions

  sidebar :user_information, only: [:show, :edit] do
    user = job_user.user

    user_query = AdminHelpers::Link.query(:user_id, user.id)
    from_user_query = AdminHelpers::Link.query(:from_user_id, user.id)
    to_user_query = AdminHelpers::Link.query(:to_user_id, user.id)

    ul do
      li(
        link_to(
          I18n.t('admin.user.primary_language', lang: user.language.display_name),
          admin_language_path(user.language)
        )
      )
    end

    ul do
      li(
        link_to(
          I18n.t('admin.counts.applications', count: user.job_users.count),
          admin_job_users_path + user_query
        )
      )
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

  sidebar :documents, only: [:show, :edit] do
    user = job_user.user
    ul do
      user.user_documents.
        includes(:document).
        order(created_at: :desc).
        limit(50).
        each do |user_document|
        doc = user_document.document
        li download_link_to(
          title: "##{doc.id} #{user_document.category}",
          url: doc.url,
          file_name: doc.document_file_name
        )
      end
    end
  end

  SET_JOB_USER_TRANSLATION = lambda do |job_user, permitted_params|
    return unless job_user.persisted? && job_user.valid?

    translation_params = {
      name: permitted_params.dig(:job_user, :apply_message)
    }
    job_user.set_translation(translation_params)
  end

  after_create do |job_user|
    SET_JOB_USER_TRANSLATION.call(job_user, permitted_params)
  end

  after_save do |job_user|
    SET_JOB_USER_TRANSLATION.call(job_user, permitted_params)
  end

  sidebar :app, only: [:show, :edit] do
    ul do
      li(
        link_to(
          I18n.t('admin.view_in_app.candidates'),
          FrontendRouter.draw(
            :job_user_for_company,
            job_id: job_user.job_id,
            job_user_id: job_user.id
          ),
          target: '_blank'
        )
      )
    end
  end

  permit_params do
    [:user_id, :job_id, :accepted, :will_perform, :performed, :apply_message]
  end

  controller do
    def scoped_collection
      super.includes(
        :user,
        :frilans_finans_invoice,
        job: [:translations, :language]
      )
    end
  end
end
