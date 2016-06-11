# frozen_string_literal: true
class UserLanguage < ApplicationRecord
  PROFICIENCY_RANGE = 1..10

  belongs_to :language
  belongs_to :user

  validates :language, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true, uniqueness: { scope: :language }
  validates :proficiency, numericality: { only_integer: true }, inclusion: PROFICIENCY_RANGE, allow_nil: true # rubocop:disable Metrics/LineLength
end

# == Schema Information
#
# Table name: user_languages
#
#  id          :integer          not null, primary key
#  language_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  proficiency :integer
#
# Indexes
#
#  index_user_languages_on_language_id              (language_id)
#  index_user_languages_on_language_id_and_user_id  (language_id,user_id) UNIQUE
#  index_user_languages_on_user_id                  (user_id)
#  index_user_languages_on_user_id_and_language_id  (user_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_0be39eaff3  (language_id => languages.id)
#  fk_rails_db4f7502c2  (user_id => users.id)
#
