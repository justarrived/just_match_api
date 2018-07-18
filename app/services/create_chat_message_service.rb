# frozen_string_literal: true

class CreateChatMessageService
  SEND_IF_NO_MESSAGE_IN_HOURS = 1

  def self.create(chat:, author:, body:, language_id:)
    last_chat_message = chat.messages.last

    message = chat.create_message(author: author, body: body, language_id: language_id)
    return message unless message.valid?

    ProcessTranslationJob.perform_later(translation: message.original_translation)

    if send_notification?(message: message, last_message: last_chat_message)
      NewChatMessageNotifier.call(chat: chat, message: message, author: author)
    end

    send_admin_notification(message)

    message
  end

  def self.send_notification?(message:, last_message:)
    return true if last_message.nil? # No previous messages have been sent..

    last_message.created_before?(SEND_IF_NO_MESSAGE_IN_HOURS.hours.ago)
  end

  def self.send_admin_notification(message)
    return unless message.valid?
    return if message.author.admin?

    # Send a notification to main support user if message not authored by an admin
    envelope = ChatMailer.new_message_email(
      user: User.main_support_user,
      chat: message.chat,
      message: message,
      author: message.author
    )
    DeliverNotification.call(envelope)
  end
end
