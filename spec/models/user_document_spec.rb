# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserDocument, type: :model do
  described_class::CATEGORIES.each do |name, _value|
    it "has field name translation for document category: #{name}" do
      key = "user_document.categories.#{name}"
      expect(I18n.t(key)).not_to include('translation missing')
    end

    it "has description translation for document category: #{name}" do
      key = "user_document.categories.#{name}_description"
      expect(I18n.t(key)).not_to include('translation missing')
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
#  fk_rails_55c37c820d  (user_id => users.id)
#  fk_rails_9a2a0b4576  (document_id => documents.id)
#
