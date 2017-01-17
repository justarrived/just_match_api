# frozen_string_literal: true
class ResetPasswordNotifier < BaseNotifier
  def self.call(user:)
    notify do
      UserMailer.
        reset_password_email(user: user)
    end
  end
end
