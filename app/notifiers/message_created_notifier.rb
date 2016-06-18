# frozen_string_literal: true
class MessageCreatedNotifier
  def self.call(chat:, message:, author:)
    chat.users.each do |user|
      next if user == author

      ChatMailer.new_message_email(
        user: user,
        chat: chat,
        message: message,
        author: author
      ).deliver_later
    end
  end
end
