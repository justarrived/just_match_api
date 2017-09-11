# frozen_string_literal: true

require 'honey_format'
require 'seeds/base_seed'

class OccupationSeed < BaseSeed
  def self.call
    new.call
  end

  def call
    log_seed(Occupation) do
      csv_string = File.read(Rails.root.join('data', 'occupations.csv').to_s)
      csv = HoneyFormat::CSV.new(csv_string)

      sv_lang = Language.find_by(lang_code: :sv)
      en_lang = Language.find_by(lang_code: :en)
      ar_lang = Language.find_by(lang_code: :ar)
      root_occupation = nil

      csv.rows.each do |row|
        sv, en, ar = row.to_a
        is_root_occupation = false

        # Root occupations have a __ prefix
        if sv.start_with?('__')
          sv = sv.gsub(/__/, '')
          root_occupation = nil
          is_root_occupation = true
        end

        occupation = Occupation.create!(
          language: sv_lang,
          parent: root_occupation
        )
        occupation.set_translation({ name: sv }, sv_lang)
        occupation.set_translation({ name: en }, en_lang)
        occupation.set_translation({ name: ar }, ar_lang)

        root_occupation = occupation if is_root_occupation

        occupation
      end
    end
  end
end
