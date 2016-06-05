# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  def contact_email
    ContactMailer.contact_email(
      name: 'Watman',
      email: 'watman@example.com',
      body: 'Something, something darkside'
    )
  end
end
