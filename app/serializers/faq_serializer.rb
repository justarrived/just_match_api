# frozen_string_literal: true

class FaqSerializer < ApplicationSerializer
  ATTRIBUTES = [].freeze
  attributes ATTRIBUTES

  belongs_to :language

  attribute :language_id # Inline the language id to make it easier for clients

  attribute :question do
    object.original_question
  end

  attribute :answer do
    object.original_answer
  end

  attribute :translated_text do
    {
      question: object.translated_question,
      answer: object.translated_answer,
      language_id: object.translated_language_id
    }
  end
end

# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  answer      :text
#  question    :text
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_faqs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_24be635445  (language_id => languages.id)
#
