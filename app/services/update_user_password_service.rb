# frozen_string_literal: true
module UpdateUserPasswordService
  def self.call(user:, new_password:)
    return false unless User.valid_password_format?(new_password)

    user.generate_one_time_token
    user.password = new_password
    user.save!

    # Destroy all other user sessions
    user.auth_tokens.destroy_all

    ChangedPasswordNotifier.call(user: user)

    true
  end
end
