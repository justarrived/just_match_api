# frozen_string_literal: true
require 'seeds/base_seed'

class LanguageSeed < BaseSeed
  def self.call
    new.call
  end

  def call
    log_seed(Language) do
      available_locales = I18n.available_locales.map(&:to_s)

      csv_string = File.read(Rails.root.join('data', 'languages.csv').to_s)
      csv = HoneyFormat::CSV.new(csv_string)

      csv.rows.each do |language|
        lang_code = language.lang_code

        en_name = language.en_name
        sv_name = I18nData.languages('SV')[lang_code.upcase]
        ar_name = I18nData.languages('AR')[lang_code.upcase]
        fa_name = I18nData.languages('FA')[lang_code.upcase]
        ti_name = I18nData.languages('TI')[lang_code.upcase]
        ps_name = I18nData.languages('PS')[lang_code.upcase]

        # Languages with missing translations
        fa_af_name = fa_name
        ku_name = en_name

        Language.find_or_create_by!(
          lang_code: lang_code,
          en_name: en_name,
          sv_name: sv_name,
          ar_name: ar_name,
          fa_name: fa_name,
          fa_af_name: fa_af_name,
          ku_name: ku_name,
          ti_name: ti_name,
          ps_name: ps_name,
          direction: language.direction,
          local_name: language.local_name,
          system_language: available_locales.include?(lang_code)
        )
      end
    end
  end
end
