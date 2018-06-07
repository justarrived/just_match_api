# frozen_string_literal: true

ActiveAdmin.register FrilansFinansInvoice do
  menu parent: 'Jobs', if: proc { current_active_admin_user.super_admin? }

  batch_action :destroy, false

  scope :all, default: true
  scope :activated
  scope :pre_report
  scope :not_paid
  scope :paid
  scope :needs_frilans_finans_id
  scope :uncancelled_jobs

  filter :activated
  filter :ff_invoice_number
  filter :frilans_finans_id
  filter :ff_status
  filter :just_arrived_contact, collection: -> { User.delivery_users }
  filter :company
  filter :user
  filter :job, collection: -> { Job.with_translations }
  filter :express_payment
  filter :ff_pre_report
  filter :ff_amount
  filter :ff_gross_salary
  filter :ff_sent_at

  # rubocop:disable Metrics/LineLength
  confirm_msg = I18n.t('admin.confirm_dialog_title')
  batch_action :sync_with_frilans_finans, confirm: confirm_msg do |ids|
    collection.where(id: ids).find_each(batch_size: 500).each do |ff_invoice|
      if ff_invoice.frilans_finans_id
        SyncFrilansFinansInvoiceService.call(frilans_finans_invoice: ff_invoice)
      else
        CreateFrilansFinansInvoiceService.create(ff_invoice: ff_invoice)
      end
    end

    message = I18n.t('admin.ff_remote_sync.msg_multiple')
    redirect_to collection_path, notice: message
  end

  member_action :remove_frilans_finans_id, method: :post, confirm: confirm_msg do
    ff_invoice = resource
    invoice = ff_invoice.invoice

    unless invoice
      message = I18n.t('admin.ff_remove_id.invoice_blank_error')
      redirect_to(resource_path(ff_invoice), alert: message)
      return
    end

    unless invoice.destroy
      message = I18n.t('admin.ff_remove_id.invalid_invoice_delete')
      redirect_to(resource_path(ff_invoice), alert: message)
      return
    end

    ff_invoice.frilans_finans_id = nil
    ff_invoice.activated = false
    ff_invoice.set_remote_id
    ff_invoice.save

    if ff_invoice.errors.any?
      message_parts = [I18n.t('admin.ff_remove_id.invalid')] + ff_invoice.errors.full_messages
      redirect_to(resource_path(resource), alert: message_parts.join(', '))
      return
    end

    message = I18n.t('admin.ff_remove_id.action_success')
    redirect_to(resource_path(ff_invoice), notice: message)
  end

  member_action :sync_with_frilans_finans, method: :post, if: proc { AppConfig.frilans_finans_active? } do
    ff_invoice = resource

    if ff_invoice.frilans_finans_id
      SyncFrilansFinansInvoiceService.call(frilans_finans_invoice: ff_invoice)
    else
      CreateFrilansFinansInvoiceService.create(ff_invoice: ff_invoice)
    end

    message = I18n.t('admin.ff_remote_sync.msg')
    redirect_to(resource_path(resource), notice: message)
  end

  action_item :view, only: :show, if: proc { AppConfig.frilans_finans_active? } do
    title = I18n.t('admin.ff_remote_sync.post_btn')
    path = sync_with_frilans_finans_admin_frilans_finans_invoice_path(resource)
    link_to title, path, method: :post
  end

  member_action :send_employment_certificate, method: :post, if: proc { AppConfig.frilans_finans_active? } do
    ff_invoice = resource
    attributes = { invoice_ids: [ff_invoice.frilans_finans_id] }
    FrilansFinansAPI::EmploymentCertificate.create(attributes: attributes)
    message = I18n.t('admin.send_employment_certificate.msg')
    redirect_to(resource_path(resource), notice: message)
  end

  action_item :view, only: :show, if: proc { resource.frilans_finans_id } do
    title = I18n.t('admin.send_employment_certificate.post_btn')
    path = send_employment_certificate_admin_frilans_finans_invoice_path(resource)
    message = I18n.t('admin.frilans_finans_invoice.activate_confirmation')
    link_to title, path, method: :post, data: { confirm: message }
  end

  member_action :create_invoice, method: :post do
    ff_invoice = resource
    job_user = ff_invoice.job_user
    invoice = Invoice.new(job_user: job_user, frilans_finans_invoice: ff_invoice)

    if invoice.save
      message = I18n.t('admin.create_invoice.success_msg')
      InvoiceCreatedNotifier.call(job: job_user.job, user: job_user.user)
      redirect_to(resource_path(resource), notice: message)
    else
      message = invoice.errors.full_messages.join(".\n")
      redirect_to(resource_path(resource), alert: message)
    end
  end

  action_item :view, only: :show, if: -> { !resource.invoice && AppConfig.frilans_finans_active? } do
    title = safe_join([
                        envelope_icon_png(html_class: 'btn-icon'),
                        I18n.t('admin.create_invoice.post_btn')
                      ])

    path = create_invoice_admin_frilans_finans_invoice_path(resource)
    link_to title, path, method: :post
  end
  # rubocop:enable Metrics/LineLength

  index do
    selectable_column

    column :id
    column :activated
    column :ff_status do |ff_invoice|
      paid_status = FrilansFinansInvoice::FF_PAID_STATUS
      default_status_name = I18n.t('admin.frilans_finans_invoice.not_paid')
      status_tag(
        ff_invoice.ff_status_name(with_id: true) || default_status_name,
        ff_invoice.ff_status == paid_status ? :yes : :warning
      )
    end
    column :ff_amount
    column :user
    column :job do |ff_invoice|
      job = ff_invoice.job
      link_to(truncate(job.original_name), admin_job_path(job))
    end

    actions
  end

  show do |frilans_finans_invoice|
    locals = {
      frilans_finans_invoice: frilans_finans_invoice,
      job: frilans_finans_invoice.job
    }
    render partial: 'admin/frilans_finans_invoices/show', locals: locals
  end

  permit_params do
    %i(express_payment)
  end

  csv do
    column :id
    column :activated

    column(:job) { |ff_invoice| ff_invoice.job.report_name }
    column(:user) { |ff_invoice| ff_invoice.user.name }

    column(:invoice_amount) { |ff_invoice| ff_invoice.job.invoice_amount }

    column :frilans_finans_id
    column :ff_pre_report
    column :ff_amount
    column :ff_gross_salary
    column :ff_net_salary
    column :ff_payment_status
    column :ff_approval_status
    column :ff_status
    column :ff_sent_at
    column :express_payment

    column :created_at
    column :updated_at
    column :job_user_id
  end

  controller do
    def scoped_collection
      super.includes(job: %i(language translations))
    end
  end
end
