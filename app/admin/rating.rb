# frozen_string_literal: true
ActiveAdmin.register Rating do
  scope :all, default: true

  filter :score
  filter :from_user
  filter :to_user
  filter :job
  filter :created_at

  index do
    column :id
    column :score
    column :job
    column :from_user
    column :to_user
    column :comment
    column :created_at
  end

  permit_params do
    [
      :from_user_id,
      :to_user_id,
      :job_id,
      :score
    ]
  end
end
