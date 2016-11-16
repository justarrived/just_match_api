# frozen_string_literal: true
ActiveAdmin.register FrilansFinansInvoice do
  batch_action :destroy, false

  scope :all, default: true
  scope :activated
  scope :pre_report
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

  index do
    column :id
    column :activated
    column :ff_status
    column :ff_amount
    column :user
    column :job
    column :frilans_finans_id

    actions
  end

  permit_params do
    [:activated, :job_user_id, :express_payment]
  end
end
