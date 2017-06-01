# frozen_string_literal: true

require 'seeds/base_seed'

module Dev
  class ChatSeed < BaseSeed
    def self.call(users:, languages:)
      max_chats = max_count_opt('MAX_CHATS', 50)
      max_chat_messages = max_count_opt('MAX_CHAT_MESSAGES', 10)

      log_seed(Chat, Message) do
        max_chats.times do
          user = users.sample
          other_user = (users - [user]).sample
          user_ids = User.where(id: [user.id, other_user.id])
          chat = Chat.find_or_create_private_chat(user_ids)
          language = languages.sample

          Random.rand(1..max_chat_messages).times do
            author = [user, other_user].sample
            body = Faker::Hipster.paragraph(2)
            message = Message.create!(
              body: body,
              chat: chat,
              author: author,
              language: language
            )
            message.set_translation(body: body)
          end
        end
      end
    end
  end
end
