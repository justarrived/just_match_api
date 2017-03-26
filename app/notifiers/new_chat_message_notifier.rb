# frozen_string_literal: true
class NewChatMessageNotifier < BaseNotifier
  def self.call(chat:, message:, author:)
    chat.users.each do |user|
      next if user == author

      envelope = ChatMailer.new_message_email(
        user: user,
        chat: chat,
        message: message,
        author: author
      )
      notify(envelope, user: user, locale: user.locale)
    end
  end
end
