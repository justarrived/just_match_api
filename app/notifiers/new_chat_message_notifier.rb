# frozen_string_literal: true
class NewChatMessageNotifier < BaseNotifier
  def self.call(chat:, message:, author:)
    chat.users.each do |user|
      next if user == author

      notify(user: user, locale: user.locale) do
        ChatMailer.new_message_email(
          user: user,
          chat: chat,
          message: message,
          author: author
        )
      end
    end
  end
end
