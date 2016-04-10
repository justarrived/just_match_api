# frozen_string_literal: true
require 'seeds/base_seed'

class LanguageSeed < BaseSeed
  def self.call
    new.call
  end

  def call
    log_seed(Language) do
      available_locales = I18n.available_locales.map(&:to_s)

      csv_string = File.read("#{Rails.root}/data/languages.csv")
      csv = HoneyFormat::CSV.new(csv_string)

      csv.rows.each do |language|
        lang_code = language.lang_code
        Language.create!(
          lang_code: lang_code,
          en_name: language.en_name,
          direction: language.direction,
          local_name: language.local_name,
          system_language: available_locales.include?(lang_code)
        )
      end
    end
  end
end
