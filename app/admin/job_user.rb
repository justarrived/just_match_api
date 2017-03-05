# frozen_string_literal: true
ActiveAdmin.register JobUser do
  menu parent: 'Jobs', priority: 2

  batch_action :destroy, false
  batch_action :accept_and_notify_user do |ids|
    job_users = JobUser.where(id: ids)
    success_count = 0
    ignore_count = 0
    fail_ids = []

    job_users.each do |job_user|
      if job_user.accepted
        ignore_count += 1
        next
      end

      if job_user.update(accepted: true)
        owner = job_user.job.owner
        success_count += 1
        ApplicantAcceptedNotifier.call(job_user: job_user, owner: owner)
      else
        fail_ids << job_user.id
      end
    end

    if fail_ids.empty?
      notice = I18n.t(
        'admin.job_user.batch_action.accepted.success_msg',
        success_count: success_count,
        ignore_count: ignore_count
      )
      redirect_to collection_path, notice: notice
    else
      notice = I18n.t(
        'admin.job_user.batch_action.accepted.fail_msg',
        fail_count: fail_ids.length,
        fail_ids: fail_ids.join(', '),
        success_count: success_count,
        ignore_count: ignore_count
      )
      redirect_to collection_path, alert: notice
    end
  end

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

    users = JobUser.where(id: ids).includes(:user).map(&:user)
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
      users: JobUser.where(id: ids).includes(:user).map(&:user),
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

  scope :all
  scope :visible, default: true
  scope :shortlisted
  scope :accepted
  scope :will_perform
  scope :verified
  scope :withdrawn

  filter :user_first_name_cont, as: :string, label: I18n.t('admin.user.first_name')
  filter :user_last_name_cont, as: :string, label: I18n.t('admin.user.last_name')
  filter :job_translations_name_cont, as: :string, label: I18n.t('admin.job.name_search')
  filter :user_verified_eq, as: :boolean, label: I18n.t('admin.user.verified')
  filter :job, collection: -> { Job.with_translations.order_by_name.limit(200) }
  filter :frilans_finans_invoice, collection: -> { FrilansFinansInvoice.order(id: :desc) }
  filter :invoice, collection: -> { Invoice.order(id: :desc) }
  filter :accepted
  filter :will_perform
  filter :performed
  filter :shortlisted
  filter :application_withdrawn
  filter :updated_at
  filter :created_at
  filter :translations_apply_message_cont, as: :string, label: I18n.t('admin.job_user.apply_message') # rubocop:disable Metrics/LineLength

  index do
    selectable_column

    column :id
    column :user
    column :job
    column :job_start_date { |job_user| job_user.job.job_date }
    column :city do |job_user|
      "U: #{job_user.user.city}, J: #{job_user.job.city}"
    end
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

  sidebar :relations, only: [:show, :edit] do
    render partial: 'admin/users/relations_list', locals: { user: job_user.user }
  end

  sidebar :latest_applications, only: [:show, :edit] do
    user = job_user.user
    ul do
      user.job_users.includes(job: [:translations]).recent(50).each do |job_user|
        li link_to("##{job_user.id} " + job_user.job.name, admin_job_user_path(job_user))
      end
    end
  end

  sidebar :documents, only: [:show, :edit] do
    user = job_user.user
    user_documents = user.user_documents.recent(50).includes(:document)

    locals = { user_documents: user_documents }
    render partial: 'admin/users/documents_list', locals: locals
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
          I18n.t('admin.view_in_app.job'),
          FrontendRouter.draw(:job, id: job_user.job_id),
          target: '_blank'
        )
      )
    end
  end

  permit_params do
    [
      :user_id, :job_id, :accepted, :will_perform, :performed, :apply_message,
      :application_withdrawn, :shortlisted
    ]
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
