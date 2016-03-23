# frozen_string_literal: true
class ResetPasswordNotifier
  def self.call(user:)
    UserMailer.
      reset_password_email(user: user).
      deliver_later
  end
end
