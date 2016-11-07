# frozen_string_literal: true
ActiveAdmin.register Message do
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

  include AdminHelpers::MachineTranslation::Actions

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
