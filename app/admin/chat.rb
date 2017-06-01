# frozen_string_literal: true

ActiveAdmin.register Chat do
  menu parent: 'Chats', url: -> { admin_chats_path(order: 'updated_at_desc') }

  batch_action :destroy, false

  filter :users
  filter :updated_at
  filter :created_at

  index do
    column :id
    column(:users) do |chat|
      safe_join(
        chat.users.map do |user|
          user_query_param = AdminHelpers::Link.query(:chat_users_user_id, user.id)
          link_to(user.display_name, admin_chats_path + user_query_param)
        end,
        ', '
      )
    end
    column(:message_count) { |chat| chat.messages.length }
    column(:last_message_at, sortable: :updated_at) do |chat|
      distance_of_time_in_words(Time.zone.now, chat.updated_at) + ' ago'
    end

    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs I18n.t('admin.chat.form.messages_title') do
      f.has_many :messages, allow_destroy: false, new_record: true do |ff|
        message = ff.object
        if message.persisted?
          attributes_table_for message do
            row :id { link_to(message.display_name, admin_message_path(message)) }
            row :language { message.language }
            row :from do
              link_to(message.author.display_name, admin_user_path(message.author))
            end
            row :created_at { datetime_ago_in_words(message.created_at) }
            row :body { simple_format(message.body) }
          end
        else
          ff.semantic_errors(*message&.errors&.keys)

          ff.input :author, as: :select, collection: f.object.users
          ff.input :language, as: :select, collection: Language.system_languages.order(:en_name) # rubocop:disable Metrics/LineLength
          ff.input :body, as: :text
        end
      end
    end

    f.actions
  end

  show do |chat|
    attributes_table do
      row :id
      row :updated_at
      row :created_at
      row :message_count { chat.messages.count }
      row :users do
        safe_join(
          chat.users.map { |user| link_to(user.display_name, admin_user_path(user)) },
          ', '
        )
      end
    end

    chat.messages.
      includes(:author, :language, :translations).
      order(created_at: :desc).
      each do |message|
      attributes_table do
        row :id { link_to(message.display_name, admin_message_path(message)) }
        row :language { message.language }
        row :from do
          link_to(message.author.display_name, admin_user_path(message.author))
        end
        row :created_at { datetime_ago_in_words(message.created_at) }
        row :body { simple_format(message.body) }
      end
    end
  end

  controller do
    def scoped_collection
      super.includes(:users, :messages)
    end

    def update_resource(chat, params_array)
      chat_params = params_array.first

      chat_messages_attrs = chat_params.delete(:messages_attributes)
      message_ids_param = (chat_messages_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:id],
          language_id: attrs[:language_id],
          author_id: attrs[:author_id],
          body: attrs[:body]
        }
      end
      SetChatMessagesService.call(chat: chat, message_ids_param: message_ids_param)
      super
    end
  end

  permit_params do
    [messages_attributes: %i(author_id language_id body _destroy id)]
  end
end
