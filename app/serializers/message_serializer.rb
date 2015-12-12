class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_one :chat
  has_one :author
  has_one :language
end
