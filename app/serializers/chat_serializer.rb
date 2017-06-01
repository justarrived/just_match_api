# frozen_string_literal: true

class ChatSerializer < ApplicationSerializer
  ATTRIBUTES = [:created_at].freeze
  attributes ATTRIBUTES

  link(:self) { api_v1_chat_url(object) }

  has_many :messages do
    link(:related) { api_v1_chat_messages_url(object.id) }
  end

  has_many :users
  has_many :user_images
end

# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
