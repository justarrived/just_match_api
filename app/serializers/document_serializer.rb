# frozen_string_literal: true

class DocumentSerializer < ApplicationSerializer
  ATTRIBUTES = %i(one_time_token one_time_token_expires_at).freeze
  attributes ATTRIBUTES

  attribute :document_url do
    object.document.url
  end
end

# == Schema Information
#
# Table name: documents
#
#  id                        :integer          not null, primary key
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  document_file_name        :string
#  document_content_type     :string
#  document_file_size        :integer
#  document_updated_at       :datetime
#  text_content              :text
#
