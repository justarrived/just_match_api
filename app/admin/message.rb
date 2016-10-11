# frozen_string_literal: true
ActiveAdmin.register Message do
  permit_params do
    [
      :chat_id,
      :author_id,
      :integer,
      :language_id,
      :body
    ]
  end
end
