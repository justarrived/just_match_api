# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatSerializer < ActiveModel::Serializer
  attributes :id

  has_many :messages
  has_many :users
end
