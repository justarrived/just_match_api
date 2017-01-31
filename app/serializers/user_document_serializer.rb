# frozen_string_literal: true
class UserDocumentSerializer < ApplicationSerializer
  ATTRIBUTES = [:category].freeze
  attributes ATTRIBUTES

  attribute :category_name

  has_one :user
  has_one :document

  def category_name
    object.category
  end
end
