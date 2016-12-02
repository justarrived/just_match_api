# frozen_string_literal: true
ActiveAdmin.register FrilansFinansApiLog do
  menu parent: 'Frilans Finans'

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
    selectable_column

    column :id
    column :status
    column :verb
    column :uri
    column :created_at

    actions
  end
end
