# frozen_string_literal: true
ActiveAdmin.register JobUser do
  scope :all, default: true
  scope :accepted
  scope :will_perform

  filter :user
  filter :job
  filter :frilans_finans_invoice
  filter :invoice
  filter :updated_at
  filter :created_at

  index do
    column :id
    column :user
    column :job
    column :accepted
    column :will_perform
    column :performed
    column :frilans_finans_invoice
    column :updated_at

    actions
  end

  permit_params do
    [:accepted, :will_perform, :performed, :apply_message]
  end
end
