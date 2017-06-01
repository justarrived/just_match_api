# frozen_string_literal: true

class UserDocumentSerializer < ApplicationSerializer
  ATTRIBUTES = %i(category created_at).freeze
  attributes ATTRIBUTES

  attribute :category_name

  has_one :user
  has_one :document

  def category_name
    object.category
  end
end

# == Schema Information
#
# Table name: user_documents
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  document_id :integer
#  category    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_documents_on_document_id  (document_id)
#  index_user_documents_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_55c37c820d  (user_id => users.id)
#  fk_rails_9a2a0b4576  (document_id => documents.id)
#
