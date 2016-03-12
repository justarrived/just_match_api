# frozen_string_literal: true
module Api
  module V1
    module Chats
      class MessagesController < BaseController
        before_action :require_user
        before_action :set_chat

        after_action :verify_authorized, only: []

        resource_description do
          resource_id 'chat_messages'
          api_versions '1.0'
          name 'Chat messages'
          short 'API for managing chat messages'
          description '
            Create and list chat messages.
          '
          formats [:json]
        end

        api :GET, '/chats/:id/messages', 'Get chat messages.'
        description 'Returns messages in chat.'
        example Doxxer.read_example(Message, plural: true)
        def index
          @messages = @chat.messages.includes(:language).includes(:author)
          render json: @messages
        end

        api :POST, '/chats/:id/messages', 'Create new chat message.'
        description 'Creates and returns new message.'
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Message attributes', required: true do
            param :body, String, desc: 'Message body', required: true
            param :language_id, Integer, desc: 'Language id', required: true
          end
        end
        example Doxxer.read_example(Message)
        def create
          lang = message_params[:language_id]
          body = message_params[:body]
          author = current_user
          @message = @chat.create_message(author: author, body: body, language_id: lang)

          if @message.valid?
            render json: @message, include: %w(author language), status: :created
          else
            render json: @message.errors, status: :unprocessable_entity
          end
        end

        private

        def set_chat
          @chat = current_user.chats.find(params[:id])
        end

        def message_params
          jsonapi_params.permit(:body, :language_id)
        end
      end
    end
  end
end
