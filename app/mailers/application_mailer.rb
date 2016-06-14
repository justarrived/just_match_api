# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  DEFAULT_EMAIL = 'JustArrived <hello@justarrived.se>'
  default from: DEFAULT_EMAIL
end
