# frozen_string_literal: true
class ContactNotifier
  def self.call(contact:)
    name = contact.name
    email = contact.email
    body = contact.body

    ContactMailer.
      contact_email(name: name, email: email, body: body).
      deliver_later
  end
end
