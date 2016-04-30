# frozen_string_literal: true
require 'seeds/production/blazer_seed'
require 'seeds/production/language_seed'
require 'seeds/production/hourly_pay_seed'

if Rails.env.production? || ENV.fetch('LIVE_FRILANS_FINANS_SEED', false)
  require 'seeds/production/currency_seed'
  require 'seeds/production/category_seed'
else
  require 'seeds/dev/currency_seed'
  require 'seeds/dev/category_seed'

  CurrencySeed = Dev::CurrencySeed
  CategorySeed = Dev::CategorySeed
end

BlazerSeed.call
CategorySeed.call
CurrencySeed.call
LanguageSeed.call
HourlyPaySeed.call
