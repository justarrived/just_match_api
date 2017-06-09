# frozen_string_literal: true

class AddLangNamesDataToLanguages < ActiveRecord::Migration[4.2]
  def up
    Language.all.map do |language|
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

      language.update(
        sv_name: sv_name,
        ar_name: ar_name,
        fa_name: fa_name,
        fa_af_name: fa_af_name,
        ku_name: ku_name,
        ti_name: ti_name,
        ps_name: ps_name
      )
    end
  end

  def down
    Language.all.map do |language|
      language.update(
        sv_name: nil,
        ar_name: nil,
        fa_name: nil,
        fa_af_name: nil,
        ku_name: nil,
        ti_name: nil,
        ps_name: nil
      )
    end
  end
end
