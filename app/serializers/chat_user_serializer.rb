class ChatUserSerializer < ActiveModel::Serializer
  attributes :id
  has_one :chat
  has_one :user
end
