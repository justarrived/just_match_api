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

  controller do
    def scoped_collection
      super.includes(job: %i(language translations))
    end
  end
end
