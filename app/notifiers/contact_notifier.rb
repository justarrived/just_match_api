# frozen_string_literal: true
class ContactNotifier < BaseNotifier
  def self.call(contact:)
    name = contact.name
    email = contact.email
    body = contact.body

    notify do
      ContactMailer.
        contact_email(name: name, email: email, body: body)
    end
  end
end
