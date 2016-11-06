# frozen_string_literal: true
class CreateChatMessageService
  SEND_IF_NO_MESSAGE_IN_HOURS = 6

  def self.create(chat:, author:, body:, language_id:)
    last_chat_message = chat.messages.last

    message = chat.create_message(author: author, body: body, language_id: language_id)
    if message.valid?
      MachineTranslationsJob.perform_later(message.original_translation)
    end

    if send_notification?(message: message, last_message: last_chat_message)
      NewChatMessageNotifier.call(chat: chat, message: message, author: author)
    end

    message
  end

  def self.send_notification?(message:, last_message:)
    return false unless message.valid?
    return true if last_message.nil? # No previous messages have been sent..

    last_message.created_before?(SEND_IF_NO_MESSAGE_IN_HOURS.hours.ago)
  end
end
