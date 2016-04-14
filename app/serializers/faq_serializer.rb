# frozen_string_literal: true
class FaqSerializer < ActiveModel::Serializer
  ATTRIBUTES = [:question, :answer].freeze

  attributes ATTRIBUTES

  belongs_to :language
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
