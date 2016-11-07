# frozen_string_literal: true
ActiveAdmin.register Message do
  index do
    column :id
    column :original_body
    column :author
    column :chat
    column :created_at

    actions
  end

  after_save do |message|
    translation_params = {
      name: permitted_params.dig(:message, :body)
    }
    message.set_translation(translation_params, message.language_id)
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
      super.with_translations
    end
  end
end
