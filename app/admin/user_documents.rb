# frozen_string_literal: true

ActiveAdmin.register UserDocument do
  menu parent: 'Users'

  filter :category
  filter :created_at

  index do
    selectable_column

    column :id

    column :category
    column :user
    column :url do |user_doc|
      download_link_to(url: user_doc.url, file_name: user_doc.document_file_name)
    end
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :user
      row :category
      row :document
      row :document_url do |user_doc|
        download_link_to(url: user_doc.url, file_name: user_doc.document_file_name)
      end
      row(:created_at) { |user_doc| datetime_ago_in_words(user_doc.created_at) }
    end

    active_admin_comments
  end

  permit_params do
    %i(user_id document_id category)
  end

  controller do
    def scoped_collection
      super.includes(user: [:documents])
    end
  end
end
