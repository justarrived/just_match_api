# frozen_string_literal: true
class NewChatMessageNotifier < BaseNotifier
  def self.call(chat:, message:, author:)
    chat.users.each do |user|
      next if user == author
      next if ignored?(user)

      notify(locale: user.locale) do
        ChatMailer.new_message_email(
          user: user,
          chat: chat,
          message: message,
          author: author
        ).deliver_later
      end
    end
  end
end
