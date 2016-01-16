class Message < ActiveRecord::Base
  belongs_to :chat
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :language

  validates :body, presence: true
  validates :chat, presence: true
  validates :author, presence: true
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
#  fk_rails_0f670de7ba  (chat_id => chats.id)
#  fk_rails_ab4144543f  (language_id => languages.id)
#
