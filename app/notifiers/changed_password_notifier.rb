# frozen_string_literal: true
class ChangedPasswordNotifier < BaseNotifier
  def self.call(user:)
    notify do
      UserMailer.
        changed_password_email(user: user)
    end
  end
end
