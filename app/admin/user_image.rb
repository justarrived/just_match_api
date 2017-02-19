# frozen_string_literal: true
ActiveAdmin.register UserImage do
  menu parent: 'Users'

  filter :category
  filter :created_at

  index do
    selectable_column

    column :id
    column { |user_image| image_tag(user_image.image.url(:small)) }
    column :user
    column :category
    column :created_at

    actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :category
      f.input :image, required: true, as: :file
    end

    f.actions
  end

  permit_params do
    [:user_id, :category, :image]
  end

  controller do
    def scoped_collection
      super.includes(:user)
    end
  end
end
