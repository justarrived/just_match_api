# frozen_string_literal: true
module Api
  module V1
    module Users
      class MessagesController < BaseController
        before_action :require_user
        before_action :set_user

        after_action :verify_authorized, only: []

        resource_description do
          resource_id 'user_messages'
          api_versions '1.0'
          name 'User messages'
          short 'API for managing user messages'
          description '
            Here you can find the documentation for inteteracting with user messages.
          '
          formats [:json]
        end

        ALLOWED_INCLUDES = %w(author language).freeze

        api :GET, '/users/:user_id/messages', 'Get user messages.'
        description 'Returns the message between user and logged in user.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::MessagesIndex)
        example Doxxer.read_example(Message, plural: true)
        def index
          users = User.where(id: chat_user_ids)

          chat = Chat.find_private_chat(users)
          base_messages = chat.nil? ? Message.none : chat.messages

          messages_index = Index::MessagesIndex.new(self)
          @messages = messages_index.messages(base_messages)

          api_render(@messages)
        end

        api :POST, '/users/:user_id/messages', 'Create new user message.'
        description 'Creates and returns new message.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Message attributes', required: true do
            param :body, String, desc: 'Message body', required: true
            param :'language-id', Integer, desc: 'Language id', required: true
          end
        end
        ApipieDocHelper.params(self)
        example Doxxer.read_example(Message)
        def create
          users = User.where(id: chat_user_ids)
          chat = Chat.find_or_create_private_chat(users)

          lang = message_params[:language_id]
          body = message_params[:body]
          author = current_user
          @message = chat.create_message(author: author, body: body, language_id: lang)

          if @message.valid?
            api_render(@message, status: :created)
          else
            respond_with_errors(@message)
          end
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def chat_user_ids
          [@user.id, current_user.id]
        end

        def message_params
          jsonapi_params.permit(:body, :language_id)
        end
      end
    end
  end
end
