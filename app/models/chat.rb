# frozen_string_literal: true
class Chat < ApplicationRecord
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :user_images, through: :users
  has_many :messages, dependent: :destroy

  MIN_USERS = 2
  MAX_USERS = 2
  NUMBER_OF_USERS_ERR_MSG = I18n.t(
    'errors.chat.number_of_users',
    min: MIN_USERS,
    max: MAX_USERS
  )

  def self.find_or_create_private_chat(users)
    find_private_chat(users) || create_private_chat(users)
  end

  def self.create_private_chat(users)
    if users.length >= MIN_USERS && users.length <= MAX_USERS
      create!.tap { |chat| chat.users = users }
    else
      # This isn't great since this error is lost when calling
      # #valid?, #validate, #save or #save! (implicit behavior)
      new.tap { |chat| chat.errors.add(:users, NUMBER_OF_USERS_ERR_MSG) }
    end
  end

  def self.find_private_chat(users)
    common_chats = common_chat_ids(users)
    unless common_chats.empty?
      Chat.where(id: common_chats).find_each do |chat|
        # Make sure its a private chat and not just a chat they have in common
        return chat if chat.users.length == users.length
      end
    end
    nil
  end

  def self.common_chat_ids(users)
    users.map { |user| user.chats.pluck(:id) }.inject(&:&) || []
  end

  def create_message(author:, body:, language_id:)
    language = Language.find_by(id: language_id)
    message = Message.new(
      author: author,
      body: body,
      language: language,
      chat: self
    )
    if message.save
      message.set_translation({ body: body }, language&.lang_code)
    end
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
