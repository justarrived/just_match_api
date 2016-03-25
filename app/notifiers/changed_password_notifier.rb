# frozen_string_literal: true
class ChangedPasswordNotifier
  def self.call(user:)
    UserMailer.
      changed_password_email(user: user).
      deliver_later
  end
end
