# frozen_string_literal: true

class LanguageSerializer < ApplicationSerializer
  ATTRIBUTES = %i(
    lang_code direction system_language local_name en_name sv_name ar_name
    fa_name fa_af_name ku_name ti_name ps_name
  ).freeze

  attributes ATTRIBUTES

  attribute :name do
    object.name_for(I18n.locale)
  end

  belongs_to :language { scope.fetch(:current_language) }

  attribute :language_id { scope.fetch(:current_language_id) }

  attribute :translated_text do
    {
      name: object.name_for(I18n.locale),
      language_id: scope.fetch(:current_language_id)
    }
  end

  link(:self) { api_v1_language_url(object) }
end

# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  lang_code           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  en_name             :string
#  direction           :string
#  local_name          :string
#  system_language     :boolean          default(FALSE)
#  sv_name             :string
#  ar_name             :string
#  fa_name             :string
#  fa_af_name          :string
#  ku_name             :string
#  ti_name             :string
#  ps_name             :string
#  machine_translation :boolean          default(FALSE)
#
# Indexes
#
#  index_languages_on_lang_code  (lang_code) UNIQUE
#
