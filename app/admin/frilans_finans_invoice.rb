# frozen_string_literal: true
ActiveAdmin.register FrilansFinansInvoice do
  scope :all, default: true
  scope :activated
  scope :pre_report
  scope :needs_frilans_finans_id

  filter :activated
  filter :user
  filter :job
  filter :frilans_finans_id

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
    [:activated, :job_user_id]
  end
end
