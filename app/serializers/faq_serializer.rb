# frozen_string_literal: true
class FaqSerializer < ActiveModel::Serializer
  ATTRIBUTES = [:question, :answer].freeze

  attributes ATTRIBUTES

  belongs_to :language
end
