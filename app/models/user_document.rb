# frozen_string_literal: true
class UserDocument < ApplicationRecord
  belongs_to :user
  belongs_to :document

  CATEGORIES = { cv: 1 }.freeze

  # NOTE: Figure out a good way to validate #category
  #       see https://github.com/rails/rails/issues/13971
  enum category: CATEGORIES

  validates :category, presence: true
  validates :user, presence: true
  validates :document, presence: true
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
