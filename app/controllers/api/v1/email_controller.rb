# frozen_string_literal: true

module Api
  module V1
    class EmailController < BaseController
      before_action :authorize_sender
      after_action :verify_authorized, only: []

      api :POST, '/email/receive', 'Receive email'
      description 'Receives email and adds it to the appropiate chat'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      param :ja_key, String, desc: 'Auth key (can be an URL param)', required: true
      param :from, String, desc: 'From email address', required: true
      param :to, String, desc: 'To email address', required: true
      param :subject, String, desc: 'Email subject', required: true
      param :text, String, desc: 'Email body', required: true
      def receive
        value_formatter = StringFormatter.new

        from = params[:from]
        to = params[:to]
        subject = params[:subject]
        raw_text = value_formatter.force_utf8(params[:text])
        html_body = value_formatter.force_utf8(params[:html])

        from_email = EmailAddress.normalize(from)

        user = User.includes(:language).find_by(email: from_email)
        support_user = User.main_support_user

        if user && support_user
          email_body = EmailReplyParser.parse_reply(raw_text || '')
          body = [subject, email_body].compact.join("\n\n")

          create_chat_message(author: user, receiver: support_user, body: body)
        end

        ReceivedEmail.create(
          from_address: from,
          to_address: to,
          subject: subject,
          text_body: raw_text,
          html_body: html_body
        )

        head :no_content
      end

      private

      def authorize_sender
        return if params[:ja_key] == AppSecrets.incoming_email_key

        render json: Unauthorized.add, status: :unauthorized
      end

      def create_chat_message(author:, receiver:, body:)
        chat = Chat.find_or_create_private_chat([author, receiver])
        CreateChatMessageService.create(
          chat: chat,
          author: author,
          body: body,
          language_id: author.system_language&.id
        )
      end
    end
  end
end
