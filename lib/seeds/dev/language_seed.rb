# frozen_string_literal: true
require 'seeds/dev/base_seed'

class LanguageSeed < BaseSeed
  def self.call
    log '[db:seed] Language'
    I18n.available_locales.each do |lang_code|
      Language.create!(lang_code: lang_code)
    end
  end
end
