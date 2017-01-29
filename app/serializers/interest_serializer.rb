# frozen_string_literal: true
class InterestSerializer < ApplicationSerializer
  ATTRIBUTES = [:name, :language_id].freeze

  attributes ATTRIBUTES

  link(:self) { api_v1_interest_url(object) }

  has_one :language

  attribute :translated_text do
    { name: object.translated_name, language_id: object.translated_language_id }
  end
end
