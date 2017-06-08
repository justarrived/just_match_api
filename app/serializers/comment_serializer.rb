# frozen_string_literal: true

class CommentSerializer < ApplicationSerializer
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

  has_one :owner
  has_one :language
end
# rubocop:disable Metrics/LineLength

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
#  hidden           :boolean          default(FALSE)
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_language_id                          (language_id)
#
# Foreign Keys
#
#  comments_owner_user_id_fk  (owner_user_id => users.id)
#  fk_rails_...               (language_id => languages.id)
#
