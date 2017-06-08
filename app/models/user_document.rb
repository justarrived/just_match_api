# frozen_string_literal: true

class UserDocument < ApplicationRecord
  belongs_to :user
  belongs_to :document

  CATEGORIES = {
    cv: 1,
    personal_letter: 2
  }.freeze

  # NOTE: Figure out a good way to validate #category
  #       see https://github.com/rails/rails/issues/13971
  enum category: CATEGORIES

  validates :category, presence: true
  validates :user, presence: true, uniqueness: { scope: :document }
  validates :document, presence: true, uniqueness: { scope: :user }

  delegate :url, to: :document
  delegate :document_file_name, to: :document

  # NOTE: This is necessary for nested activeadmin has_many form
  accepts_nested_attributes_for :document
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
#  fk_rails_...  (document_id => documents.id)
#  fk_rails_...  (user_id => users.id)
#
