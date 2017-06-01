# frozen_string_literal: true

class InterestSerializer < ApplicationSerializer
  ATTRIBUTES = %i(name language_id).freeze

  attributes ATTRIBUTES

  link(:self) { api_v1_interest_url(object) }

  has_one :language

  attribute :translated_text do
    { name: object.translated_name, language_id: object.translated_language_id }
  end
end

# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  name        :string
#  language_id :integer
#  internal    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_4b04e42f8f  (language_id => languages.id)
#
