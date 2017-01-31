# frozen_string_literal: true
ActiveAdmin.register Document do
  menu parent: 'Misc'

  index do
    selectable_column

    column :url { |doc| link_to(I18n.t('admin.download'), doc.url) }
    column :document_content_type
    column :document_file_size { |doc| number_to_human_size(doc.document_file_size) }
    column :created_at

    actions
  end

  show do |doc|
    attributes_table do
      user = doc.users.last
      user_doc = doc.user_documents.last

      row :document_url { link_to(I18n.t('admin.download'), doc.url) }
      row :category { user_doc&.category }
      row :user do
        link_to(user.display_name, admin_user_path(user)) if user
      end
      row :document_content_type
      row :document_file_size { number_to_human_size(doc.document_file_size) }
      row :document_file_name
      row :one_time_token
      row :one_time_token_expires_at
      row :document_updated_at { datetime_ago_in_words(doc.document_updated_at) }
      row :created_at { datetime_ago_in_words(doc.created_at) }
    end

    active_admin_comments
  end

  form do |f|
    f.inputs I18n.t('admin.upload') do
      f.input :document, required: true, as: :file
    end
    f.actions
  end

  permit_params do
    [:document]
  end

  controller do
    def scoped_collection
      super.includes(:user_documents)
    end
  end
end
