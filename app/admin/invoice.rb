# frozen_string_literal: true

ActiveAdmin.register Invoice do
  menu parent: 'Jobs', if: proc { current_active_admin_user.super_admin? }

  batch_action :destroy, false

  scope :all, default: true
  scope :needs_frilans_finans_activation

  filter :frilans_finans_invoice
  filter :user
  filter :job, collection: -> { Job.with_translations }
  filter :created_at

  index do
    column :id
    column :frilans_finans_invoice
    column :user
    column :job
    column :created_at

    actions
  end

  csv do
    column(:company) { |invoice| invoice.company&.name }
    column(:job_id) { |invoice| invoice.job.id }
    column(:ff_invoice_number) do |invoice|
      invoice.frilans_finans_invoice.ff_invoice_number
    end
    column(:frilans_finans) do |invoice|
      invoice.frilans_finans_invoice.frilans_finans_id
    end
    column(:created_at, &:created_at)
  end

  controller do
    def scoped_collection
      super.includes(:user, :frilans_finans_invoice, job: %i(language translations))
    end
  end
end
