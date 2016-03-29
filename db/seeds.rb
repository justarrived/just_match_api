# frozen_string_literal: true

require 'seeds/production/blazer_seed'
require 'seeds/production/language_seed'
require 'seeds/production/hourly_pay_seed'

BlazerSeed.call
LanguageSeed.call
HourlyPaySeed.call
