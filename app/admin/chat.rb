# frozen_string_literal: true
ActiveAdmin.register Chat do
  menu parent: 'Misc'

  batch_action :destroy, false

  show do |chat|
    attributes_table do
      row :id
      row :updated_at
      row :created_at
      row :message_count { chat.messages.count }
    end

    chat.messages.order(created_at: :desc).each do |message|
      attributes_table do
        row :id { link_to(message.display_name, admin_message_path(message)) }
        row :from do
          link_to(message.author.display_name, admin_user_path(message.author))
        end
        row :created_at { datetime_ago_in_words(message.created_at) }
        row :body { simple_format(message.body) }
      end
    end
  end
end
