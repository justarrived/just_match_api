# frozen_string_literal: true
class ContactNotifier
  def self.call(name:, email:, body:)
    ContactMailer.
      contact_email(name: name, email: email, body: body).
      deliver_later
  end
end
