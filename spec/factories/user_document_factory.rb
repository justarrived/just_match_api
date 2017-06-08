# frozen_string_literal: true

FactoryGirl.define do
  factory :user_document do
    association :user
    association :document
    category UserDocument::CATEGORIES.keys.first

    factory :user_document_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
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
#  fk_rails_...  (document_id => documents.id)
#  fk_rails_...  (user_id => users.id)
#
