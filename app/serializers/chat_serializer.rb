# frozen_string_literal: true
class ChatSerializer < ApplicationSerializer
  ATTRIBUTES = [:created_at]
  attributes *ATTRIBUTES

  has_many :messages
  has_many :users
end

# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
