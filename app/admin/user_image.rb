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

  show do
    attributes_table do
      row :id
      row :user
      row :user_image do |user_image|
        image_tag(user_image.image.url(:large))
      end
      row :created_at
      row :updated_at
      row :image_file_name
      row :image_content_type
      row :image_file_size do |user_image|
        number_to_human_size(user_image.image_file_size)
      end
      row :image_updated_at
      row :category
    end

    active_admin_comments
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
