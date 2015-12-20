module Api
  module V1
    class ChatsController < BaseController
      before_action :require_user
      before_action :set_chat, only: [:show, :update]

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
      def index
        unless current_user.admin?
          render json: { error: 'Not authed.' }, status: 401
          return
        end

        page_index = params[:page].to_i
        relations = [:users, :messages]

        @chats = Chat.all.page(page_index).includes(relations)

        render json: @chats
      end

      api :GET, '/chats/:id', 'Show chat'
      description 'Return chat.'
      example Doxxer.example_for(Chat)
      def show
        render json: @chat
      end

      api :POST, '/chats/', 'Create new chat'
      description "
        Creates and returns new chat.

        * Min #{Chat::MIN_USERS} users per chat.
        * Max #{Chat::MAX_USERS} users per chat.
      "
      param :chat, Hash, desc: 'Chat attributes', required: true do
        # rubocop:disable Metrics/LineLength
        param :user_ids, Array, of: Integer, desc: "Must be between #{Chat::MIN_USERS}-#{Chat::MAX_USERS} users per chat.", required: true
        # rubocop:enable Metrics/LineLength
      end
      example Doxxer.example_for(Chat)
      def create
        users = User.where(id: param_user_ids)
        @chat = Chat.find_or_create_private_chat(users)

        if @chat.errors[:users].empty?
          render json: @chat, include: ['users'], status: :created
        else
          render json: @chat.errors, status: :unprocessable_entity
        end
      end

      private

      def set_chat
        @chat = current_user.chats.find(params[:id])
      end

      def param_user_ids
        param_users = (params[:chat][:user_ids] || []).map(&:to_i)
        ([current_user.id] + param_users).uniq
      end
    end
  end
end
