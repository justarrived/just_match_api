# frozen_string_literal: true
class UserLanguageSerializer < ApplicationSerializer
  LANGUAGE_ATTRIBUTES = [
    :lang_code, :direction, :system_language, :local_name, :en_name, :sv_name, :ar_name,
    :fa_name, :fa_af_name, :ku_name, :ti_name, :ps_name
  ].freeze
  ATTRIBUTES = (LANGUAGE_ATTRIBUTES + [:proficiency]).freeze
  attributes ATTRIBUTES.freeze

  has_one :language
  has_one :user
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
