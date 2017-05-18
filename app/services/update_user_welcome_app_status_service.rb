# frozen_string_literal: true

class UpdateUserWelcomeAppStatusService
  def self.call(user:)
    welcome_app = WelcomeApp::Client.new

    user.update_columns( # rubocop:disable Rails/SkipsModelValidations
      has_welcome_app_account: welcome_app.user_exist?(email: user.email),
      welcome_app_last_checked_at: Time.zone.now
    )
    user
  end
end
