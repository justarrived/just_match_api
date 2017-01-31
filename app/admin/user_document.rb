# frozen_string_literal: true
ActiveAdmin.register UserDocument do
  menu parent: 'Users'

  index do
    selectable_column

    column :category
    column :user
    column :url { |user_doc| link_to(I18n.t('admin.download'), user_doc.url) }
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :user
      row :category
      row :document
      row :document_url { |user_doc| link_to(I18n.t('admin.download'), user_doc.url) }
      row :created_at { |user_doc| datetime_ago_in_words(user_doc.created_at) }
    end

    active_admin_comments
  end

  permit_params do
    [:user_id, :document_id, :category]
  end

  controller do
    def scoped_collection
      super.includes(user: [:documents])
    end
  end
end
