# frozen_string_literal: true
ActiveAdmin.register Rating do
  menu parent: 'Jobs'

  batch_action :destroy, false

  scope :all, default: true

  filter :score
  filter :job, collection: -> { Job.with_translations.recent(200) }
  filter :created_at

  index do
    column :score
    column :job
    column :from_user
    column :to_user
    column :comment
    column :created_at

    actions
  end

  permit_params do
    [
      :from_user_id,
      :to_user_id,
      :job_id,
      :score
    ]
  end

  controller do
    def scoped_collection
      super.includes(job: [:language, :translations])
    end
  end
end
