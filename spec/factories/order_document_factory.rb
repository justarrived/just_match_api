# frozen_string_literal: true

FactoryBot.define do
  factory :order_document do
    name 'MyString'
    association :document
    association :order
  end
end

# == Schema Information
#
# Table name: order_documents
#
#  id          :integer          not null, primary key
#  name        :string
#  document_id :integer
#  order_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_order_documents_on_document_id  (document_id)
#  index_order_documents_on_order_id     (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#  fk_rails_...  (order_id => orders.id)
#
