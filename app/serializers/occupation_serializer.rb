# frozen_string_literal: true

class OccupationSerializer < ApplicationSerializer
  attributes :name

  attribute :translated_text do
    {
      name: object.translated_name,
      language_id: object.translated_language_id
    }
  end

  attribute :parent_id do
    object.ancestry
  end

  belongs_to :language
end

# == Schema Information
#
# Table name: occupations
#
#  id          :integer          not null, primary key
#  name        :string
#  ancestry    :string
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_occupations_on_ancestry     (ancestry)
#  index_occupations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
