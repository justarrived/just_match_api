class Chat < ActiveRecord::Base
  has_many :chat_users
  has_many :users, through: :chat_users
  has_many :messages

  MIN_USERS = 2
  MAX_USERS = 10

  def self.find_or_create_private_chat(users)
    find_private_chat(users) || begin
      if users.length >= MIN_USERS && users.length <= MAX_USERS
        create!.tap { |chat| chat.users = users }
      else
        # TODO: This isn't great since this error is lost when calling #valid?,
        #       #validate, #save or #save!
        #       This method should be extracted to its own class/service
        new.tap do |chat|
          chat.errors.add(:users, "must be between #{MIN_USERS}-#{MAX_USERS}")
        end
      end
    end
  end

  def self.find_private_chat(users)
    common_chats = common_chat_ids(users)
    unless common_chats.empty?
      Chat.where(id: common_chats).find_each do |chat|
        # Make sure its a private chat and not just a chat in common
        return chat if chat.users.length == users.length
      end
    end
    nil
  end

  def self.common_chat_ids(users)
    users.map { |user| user.chats.pluck(:id) }.inject(&:&) || []
  end

  def create_message(author:, body:, language_id:)
    message = Message.new(
      author: author,
      body: body,
      language: Language.find_by(id: language_id)
    )
    messages << message
    message
  end
end

# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
