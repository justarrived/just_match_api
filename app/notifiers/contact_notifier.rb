# frozen_string_literal: true

class ContactNotifier < BaseNotifier
  def self.call(contact:)
    name = contact.name
    email = contact.email
    body = contact.body

    envelope = ContactMailer.contact_email(name: name, email: email, body: body)
    dispatch(envelope)
  end
end
