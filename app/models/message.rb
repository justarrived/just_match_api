# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :language, optional: true

  validates :body, presence: true, on: :create
  validates :chat, presence: true
  validates :author, presence: true

  include Translatable
  translates :body

  def created_before?(datetime)
    datetime > created_at
  end
end

# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  chat_id     :integer
#  author_id   :integer
#  integer     :integer
#  language_id :integer
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_messages_on_chat_id      (chat_id)
#  index_messages_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...           (chat_id => chats.id)
#  fk_rails_...           (language_id => languages.id)
#  messages_author_id_fk  (author_id => users.id)
#
