# frozen_string_literal: true
class ChangedPasswordNotifier < BaseNotifier
  def self.call(user:)
    envelope = UserMailer.changed_password_email(user: user)
    dispatch(envelope)
  end
end
