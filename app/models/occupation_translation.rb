# frozen_string_literal: true

class OccupationTranslation < ApplicationRecord
  belongs_to :occupation

  include TranslationModel
end

# == Schema Information
#
# Table name: occupation_translations
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  occupation_id :bigint(8)
#  language_id   :bigint(8)
#  locale        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_occupation_translations_on_language_id    (language_id)
#  index_occupation_translations_on_occupation_id  (occupation_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (occupation_id => occupations.id)
#
