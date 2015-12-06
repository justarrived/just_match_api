class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commentable_id, :commentable_type
  has_one :owner
  has_one :language
end
