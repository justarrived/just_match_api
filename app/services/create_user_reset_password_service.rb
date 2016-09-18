# frozen_string_literal: true
module CreateUserResetPasswordService
  def self.call(user:)
    user.generate_one_time_token
    user.save!
    ResetPasswordNotifier.call(user: user)

    user
  end
end
