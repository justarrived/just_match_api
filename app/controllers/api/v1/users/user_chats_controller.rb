# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserChatsController < BaseController
        before_action :require_user
        before_action :set_user
        before_action :set_chat, only: [:show]

        after_action :verify_authorized, only: []

        resource_description do
          resource_id 'user_chats'
          api_versions '1.0'
          name 'User chats'
          short 'API for managing chats'
          description '
            Here you can find the documentation for interacting with user chats.
          '
          formats [:json]
        end

        ALLOWED_INCLUDES = %w(messages).freeze

        api :GET, '/users/:user_id/chats', 'Get user chats.'
        description 'Returns user chats.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::ChatsIndex)
        example Doxxer.read_example(Chat, plural: true)
        def index
          authorize(@user)

          chats_index = Index::ChatsIndex.new(self)
          @chats = chats_index.chats(@user.chats)

          api_render(@chats, total: chats_index.count)
        end

        api :GET, '/users/:user_id/chats/:id', 'Get user chat.'
        description 'Returns user chat.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(Chat)
        def show
          authorize(@user)

          api_render(@chat)
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_chat
          chats_scope = @user.chats

          if included_resources.include?(:messages)
            chats_scope = chats_scope.includes(messages: [:author, :language])
          end

          @chat = chats_scope.find(params[:id])
        end

        def authorize(user)
          raise Pundit::NotAuthorizedError unless policy(user).chats?
        end
      end
    end
  end
end
