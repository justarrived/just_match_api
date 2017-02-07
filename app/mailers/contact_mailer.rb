# frozen_string_literal: true
class ContactMailer < ApplicationMailer
  def contact_email(name:, email:, body:)
    @subject = ['Mail from', name, email].join(' ')
    @body = body

    mail(to: DEFAULT_EMAIL, subject: @subject)
  end
end
