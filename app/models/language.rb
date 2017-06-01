# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :user_languages
  has_many :users, through: :user_languages

  has_many :jobs
  has_many :jobs, through: :job_languages

  has_many :jobs

  validates :lang_code, uniqueness: true, presence: true

  scope :system_languages, -> { where(system_language: true) }
  scope :non_system_languages, -> { where.not(system_language: true) }
  scope :rtl_languages, -> { where(direction: :rtl) }
  scope :ltr_languages, -> { where(direction: :ltr) }
  scope :machine_translation_languages, -> { system_languages.where(machine_translation: true) } # rubocop:disable Metrics/LineLength

  def self.common_working_languages_for(country:)
    country_code = country.to_s.upcase
    return where(lang_code: %i(en sv)) if country_code == 'SE'

    where(lang_code: %i(en))
  end

  def self.to_form_array(include_blank: false)
    form_array = order(:en_name).pluck(:en_name, :id)
    return form_array unless include_blank

    [[I18n.t('admin.form.no_language_chosen'), nil]] + form_array
  end

  def self.find_by_locale(locale)
    find_by(lang_code: locale)
  end

  def name_for(locale)
    translated_name = public_send(:"#{locale}_name")
    return translated_name if translated_name.present?
    return en_name if en_name.present?

    local_name
  end

  def name
    en_name
  end

  def display_name
    "##{id} " + name
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
