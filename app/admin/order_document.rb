# frozen_string_literal: true

ActiveAdmin.register OrderDocument do
  menu parent: 'Sales'

  filter :name
  filter :created_at

  index do
    selectable_column

    column :id
    column :name
    column :order
    column :url do |order_doc|
      download_link_to(url: order_doc.url, file_name: order_doc.document_file_name)
    end
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :order
      row :name
      row :document
      row :document_url do |order_doc|
        download_link_to(url: order_doc.url, file_name: order_doc.document_file_name)
      end
      row :created_at { |order_doc| datetime_ago_in_words(order_doc.created_at) }
    end

    active_admin_comments
  end

  permit_params do
    [:order_id, :document_id, :name]
  end

  controller do
    def scoped_collection
      super.includes(order: [:documents])
    end
  end
end
