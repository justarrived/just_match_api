# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderDocument, type: :model do
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
