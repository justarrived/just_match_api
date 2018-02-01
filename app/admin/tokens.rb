# frozen_string_literal: true

ActiveAdmin.register Token do
  menu parent: 'Users'

  filter :user
  filter :created_at

  index do
    column :id
    column :user
    column :created_at

    actions
  end

  permit_params do
    %i(user_id expires_at)
  end
end
