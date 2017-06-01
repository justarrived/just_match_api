# frozen_string_literal: true

class SendAdminMessage
  def self.call(users:, type:, subject:, template:, language_id:, support_user: User.main_support_user) # rubocop:disable Metrics/LineLength
    response = MessageUsers.call(
      type: type,
      users: users,
      template: template,
      subject: subject
    ) do |user, body|
      chat = Chat.find_or_create_private_chat([support_user, user])
      chat.create_message(author: support_user, body: body, language_id: language_id)
    end
    response
  end
end
