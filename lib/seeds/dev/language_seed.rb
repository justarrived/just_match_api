# frozen_string_literal: true
require 'seeds/dev/base_seed'

class LanguageSeed < BaseSeed
  def self.call
    log '[db:seed] Language'
    %w(en sv de dk no fi pl es fr hu).each do |lang_code|
      Language.create!(lang_code: lang_code)
    end
  end
end
