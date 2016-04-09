# frozen_string_literal: true
class MessageSerializer < ActiveModel::Serializer
  ATTRIBUTES = [:body].freeze

  attributes ATTRIBUTES

  has_one :chat
  has_one :author
  has_one :language
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
#  fk_rails_0f670de7ba    (chat_id => chats.id)
#  fk_rails_ab4144543f    (language_id => languages.id)
#  messages_author_id_fk  (author_id => users.id)
#
