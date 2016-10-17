# frozen_string_literal: true
ActiveAdmin.register FrilansFinansApiLog do
  scope :all, default: true
  scope :created
  scope :success
  scope :unproccessable_entity
  scope :server_error

  filter :status
  filter :verb
  filter :uri
  filter :params
  filter :response_body
  filter :created_at

  index do
    column :id
    column :status
    column :verb
    column :uri
    column :created_at
  end
end
