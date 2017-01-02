# frozen_string_literal: true
ActiveAdmin.register UserTag do
  permit_params do
    [:user_id, :tag_id]
  end
end
