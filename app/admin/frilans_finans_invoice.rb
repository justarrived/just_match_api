# frozen_string_literal: true
ActiveAdmin.register FrilansFinansInvoice do
  menu parent: 'Invoices'

  batch_action :destroy, false

  scope :all, default: true
  scope :activated
  scope :pre_report
  scope :not_paid
  scope :paid
  scope :needs_frilans_finans_id
  scope :uncancelled_jobs

  filter :activated
  filter :ff_status
  filter :user
  filter :job
  filter :express_payment
  filter :frilans_finans_id
  filter :ff_pre_report
  filter :ff_amount
  filter :ff_gross_salary
  filter :ff_sent_at

  confirm_msg = I18n.t('admin.confirm_dialog_title')
  batch_action :sync_with_frilans_finans, confirm: confirm_msg do |ids|
    collection.where(id: ids).find_each(batch_size: 1000).each do |ff_invoice|
      next if ff_invoice.frilans_finans_id.nil?

      SyncFrilansFinansInvoiceService.call(frilans_finans_invoice: ff_invoice)
    end

    message = I18n.t('admin.ff_remote_sync.msg_multiple')
    redirect_to collection_path, notice: message
  end

  member_action :sync_with_frilans_finans, method: :post do
    ff_invoice = resource
    SyncFrilansFinansInvoiceService.call(frilans_finans_invoice: ff_invoice)
    message = I18n.t('admin.ff_remote_sync.msg')
    redirect_to(resource_path(resource), notice: message)
  end

  action_item :view, only: :show, if: proc { resource.frilans_finans_id } do
    title = I18n.t('admin.ff_remote_sync.post_btn')
    path = sync_with_frilans_finans_admin_frilans_finans_invoice_path(resource)
    link_to title, path, method: :post
  end

  index do
    selectable_column

    column :id
    column :activated
    column :ff_status do |object|
      object.ff_status_name(with_id: true)
    end
    column :ff_amount
    column :user
    column :job
    column :frilans_finans_id

    actions
  end

  show do
    h3 I18n.t('admin.frilans_finans_invoice.show.general')
    attributes_table do
      row :id
      row :activated
      row :ff_amount
      row :ff_gross_salary
      row :ff_status do
        frilans_finans_invoice.ff_status_name(with_id: true)
      end
      row :frilans_finans_id
      row :user
      row :job
      row :job_user
      row :invoice
    end

    h3 I18n.t('admin.frilans_finans_invoice.show.frilans_finans')
    attributes_table do
      row :ff_amount
      row :ff_status do
        frilans_finans_invoice.ff_status_name(with_id: true)
      end
      row :ff_pre_report
      row :ff_gross_salary
      row :ff_net_salary
      row :ff_payment_status do
        frilans_finans_invoice.ff_payment_status_name(with_id: true)
      end
      row :ff_approval_status do
        frilans_finans_invoice.ff_approval_status_name(with_id: true)
      end

      row :express_payment
      row :ff_sent_at
      row :ff_last_synced_at
    end

    h3 I18n.t('admin.frilans_finans_invoice.show.dates')
    attributes_table do
      row :ff_last_synced_at
      row :updated_at
      row :created_at
    end

    active_admin_comments
  end

  permit_params do
    [:activated, :job_user_id, :express_payment]
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
end
