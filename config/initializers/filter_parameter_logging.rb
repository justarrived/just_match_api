# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i(
  password
  auth_token
  auth-token
  token
  account-clearing-number
  account-number
  account_clearing_number
  account_number
  iban
  bic
  document
  image
)
