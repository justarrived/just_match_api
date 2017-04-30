# frozen_string_literal: true

FactoryGirl.define do
  factory :order_document do
    name 'MyString'
    document nil
    order nil
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
#  fk_rails_d7df84e8b6  (document_id => documents.id)
#  fk_rails_f7fb997ee3  (order_id => orders.id)
#
