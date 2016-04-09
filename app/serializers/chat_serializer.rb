# frozen_string_literal: true
class ChatSerializer < ActiveModel::Serializer
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
