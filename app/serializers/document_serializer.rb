# frozen_string_literal: true
class DocumentSerializer < ApplicationSerializer
  ATTRIBUTES = [:one_time_token, :one_time_token_expires_at, :category].freeze
  attributes ATTRIBUTES

  attribute :category_name do
    object.category
  end

  attribute :document_url do
    object.document.url
  end
end
