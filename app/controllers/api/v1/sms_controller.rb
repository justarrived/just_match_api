# frozen_string_literal: true
module Api
  module V1
    class SmsController < BaseController
      before_action :authorize_sender
      after_action :verify_authorized, only: []

      def receive
        message_body = params['Body']
        from_number = params['From']

        user = User.includes(:language).find_by(phone: from_number)
        return head :no_content if user.nil? || support_user.nil?

        users = [support_user, user]
        chat = Chat.find_or_create_private_chat(users)
        CreateChatMessageService.create(
          chat: chat,
          author: user,
          body: message_body,
          language_id: user.language&.id
        )

        head :no_content
      end

      private

      def authorize_sender
        return if params['ja_key'] == AppSecrets.incoming_sms_key

        render json: Unauthorized.add, status: :unauthorized
      end

      def support_user
        @support_user ||= begin
          User.find_by(email: AppConfig.support_email) || User.admins.first
        end
      end
    end
  end
end
