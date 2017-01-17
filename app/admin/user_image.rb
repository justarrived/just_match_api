# frozen_string_literal: true
ActiveAdmin.register UserImage do
  menu parent: 'Users'

  index do
    selectable_column

    column :id
    column { |user_image| image_tag(user_image.image.url(:small)) }
    column :user
    column :category
    column :created_at

    actions
  end

  permit_params do
    [:user_id, :category]
  end

  controller do
    def scoped_collection
      super.includes(:user)
    end
  end
end
