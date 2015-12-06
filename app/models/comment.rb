class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'
  belongs_to :language

  validates_presence_of :owner_user_id, :commentable_id, :commentable_type, :body
end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  commentable_id   :integer
#  commentable_type :string
#  owner_user_id    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  language_id      :integer
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_language_id                          (language_id)
#
