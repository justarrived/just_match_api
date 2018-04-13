# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  NO_REPLY_EMAIL = 'no-reply@justarrived.se'
  DEFAULT_SUPPORT_EMAIL = 'Just Arrived <support@email.justarrived.se>'
  DEFAULT_EMAIL = NO_REPLY_EMAIL
  default from: DEFAULT_EMAIL
  helper :mailer
  layout 'layouts_mailer/default'

  include MailerHelper

  def product_information_email(user:, subject:, body:)
    @body = body

    mail(to: user.contact_email, subject: subject)
  end
end
