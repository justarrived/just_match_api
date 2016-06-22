# frozen_string_literal: true
class ChatMailer < ApplicationMailer
  def new_message_email(user:, chat:, message:, author:)
    @author_name = author.name
    @message_body = message.body

    @chat_url = FrontendRouter.draw(:chat, id: chat.id)

    subject = I18n.t('mailer.new_chat_message.subject', name: @author_name)
    mail(to: user.email, subject: subject)
  end
end
