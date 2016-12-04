# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  DEFAULT_EMAIL = 'Just Arrived <support@justarrived.se>'
  NO_REPLY_EMAIL = 'no-reply@justarrived.se'
  default from: DEFAULT_EMAIL
end
