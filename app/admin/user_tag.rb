# frozen_string_literal: true
ActiveAdmin.register UserTag do
  menu parent: 'Users'

  permit_params do
    [:user_id, :tag_id]
  end
end
