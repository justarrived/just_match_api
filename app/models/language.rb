# frozen_string_literal: true
class Language < ApplicationRecord
  has_many :user_languages
  has_many :users, through: :user_languages

  has_many :jobs

  validates :lang_code, uniqueness: true, presence: true

  scope :system_languages, -> { where(system_language: true) }
  scope :machine_translation_languages, -> { system_languages.where(machine_translation: true) } # rubocop:disable Metrics/LineLength

  def name
    en_name
  end

  def locale
    lang_code
  end
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
