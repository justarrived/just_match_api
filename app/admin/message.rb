# frozen_string_literal: true
ActiveAdmin.register Message do
  menu parent: 'Chats'

  batch_action :destroy, false

  index do
    selectable_column

    column :id
    column :original_body
    column :author
    column :chat
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :author
      row :chat
      row :body { |chat| simple_format(chat.body) }
      row :updated_at { |chat| datetime_ago_in_words(chat.updated_at) }
      row :created_at { |chat| datetime_ago_in_words(chat.created_at) }
    end
  end

  include AdminHelpers::MachineTranslation::Actions

  after_save do |message|
    translation_params = {
      name: permitted_params.dig(:message, :body)
    }
    message.set_translation(translation_params)
  end

  permit_params do
    [
      :chat_id,
      :author_id,
      :language_id,
      :body
    ]
  end

  controller do
    def scoped_collection
      super.with_translations.includes(:author, :chat)
    end
  end
end
