module Api
  module V1
    module Chats
      class MessagesController < BaseController
        before_action :set_chat

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
        def index
          @messages = @chat.messages.includes(:language).includes(:author)
          render json: @messages
        end

        # api :POST, '/chats/:id/messages', 'Create new chat message'
        # description 'Creates and returns new chat message.'
        # param :message, Hash, desc: 'Message attributes', required: true do
        #   param :body, String, desc: 'Message body', required: true
        #   param :language_id, Integer, desc: 'Language id', required: true
        # end
        # example Doxxer.example_for(Message)
        api :POST, '/chats/:id/messages', 'Create new chat message.'
        description 'Creates and returns new message.'
        param :message, Hash, desc: 'Message attributes', required: true do
          param :body, String, desc: 'Message body', required: true
          param :language_id, Integer, desc: 'Language id', required: true
        end
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
          params.require(:message).permit(:body, :language_id)
        end
      end
    end
  end
end
