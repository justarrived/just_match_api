# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def contact_email(name:, email:, body:)
    @subject = ['Mail from', name, email].join(' ')
    @body = body

    mail(to: 'support@justarrived.se', subject: @subject)
  end
end
