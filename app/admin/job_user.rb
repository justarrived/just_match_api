# frozen_string_literal: true
ActiveAdmin.register JobUser do
  menu parent: 'Jobs', priority: 2

  batch_action :destroy, false

  scope :all, default: true
  scope :accepted
  scope :will_perform
  scope :verified

  filter :user_verified_eq, as: :boolean, label: I18n.t('admin.user.verified')
  filter :user
  filter :job, collection: -> { Job.with_translations }
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
    attributes_table do
      row :id
      row :frilans_finans_invoice
      row :invoice
      row :user
      row :average_user_score do
        job_user.user.average_score
      end
      row :job

      row :accepted
      row :will_perform
      row :performed
      row :accepted_at

      row :apply_message
      row :language

      row :created_at { datetime_ago_in_words(job_user.created_at) }
      row :updated_at { datetime_ago_in_words(job_user.updated_at) }
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

  after_save do |job_user|
    translation_params = {
      name: permitted_params.dig(:job_user, :apply_message)
    }
    job_user.set_translation(translation_params)
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
