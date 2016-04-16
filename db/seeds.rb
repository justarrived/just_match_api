# frozen_string_literal: true

require 'seeds/production/blazer_seed'
require 'seeds/production/currency_seed'
require 'seeds/production/category_seed'
require 'seeds/production/language_seed'
require 'seeds/production/hourly_pay_seed'

BlazerSeed.call
CategorySeed.call
CurrencySeed.call
LanguageSeed.call
HourlyPaySeed.call
