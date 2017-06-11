# frozen_string_literal: true

class MessageSerializer < ApplicationSerializer
  ATTRIBUTES = %i(created_at language_id).freeze

  attributes ATTRIBUTES

  attribute :body do
    object.original_body
  end

  attribute :body_html do
    to_html(object.original_body)
  end

  attribute :translated_text do
    {
      body: object.translated_body,
      body_html: to_html(object.translated_body),
      language_id: object.translated_language_id
    }
  end

  belongs_to :chat
  belongs_to :language
  belongs_to :author

  has_one :company do
    object.author.company
  end

  has_many :user_images do
    object.author.user_images
  end

  has_many :company_images do
    object.author.company&.company_images
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
