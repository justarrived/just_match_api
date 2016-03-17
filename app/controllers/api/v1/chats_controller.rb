# frozen_string_literal: true
module Api
  module V1
    class ChatsController < BaseController
      before_action :require_user
      before_action :set_chat, only: [:show, :update]

      after_action :verify_authorized, only: []

      resource_description do
        api_versions '1.0'
        name 'Chats'
        short 'API for managing chats'
        description '
          A `Chat` has many users and messages.
        '
        formats [:json]
      end

      api :GET, '/chats/', 'List chats'
      description 'Returns a list of chats.'
      error code: 401, desc: 'Unauthorized'
      example Doxxer.read_example(Chat, plural: true)
      def index
        authorize(Chat)

        page_index = params[:page].to_i
        relations = [:users, :messages]

        @chats = Chat.all.page(page_index).includes(relations)

        api_render(@chats)
      end

      api :GET, '/chats/:id', 'Show chat'
      description 'Return chat.'
      example Doxxer.read_example(Chat)
      def show
        authorize(@chat)

        api_render(@chat, included: 'users')
      end

      api :POST, '/chats/', 'Create new chat'
      description "
        Creates and returns new chat.

        * Min #{Chat::MIN_USERS} users per chat.
        * Max #{Chat::MAX_USERS} users per chat.
      "
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Chat attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :user_ids, Array, of: Integer, desc: "Must be between #{Chat::MIN_USERS}-#{Chat::MAX_USERS} users per chat.", required: true
          # rubocop:enable Metrics/LineLength
        end
      end
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      example Doxxer.read_example(Chat)
      def create
        users = User.where(id: param_user_ids)
        @chat = Chat.find_or_create_private_chat(users)

        if @chat.errors[:users].empty?
          api_render(@chat, included: 'users', status: :created)
        else
          respond_with_errors(@chat)
        end
      end

      private

      def set_chat
        @chat = policy_scope(Chat).find(params[:id])
      end

      def param_user_ids
        user_ids = jsonapi_params[:user_ids] || []
        user_ids + [current_user.id]
      end
    end
  end
end
