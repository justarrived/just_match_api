
# frozen_string_literal: true

class UpdateUsersWelcomeAppStatusJob < ApplicationJob
  def perform(scope: User)
    scope.needs_welcome_app_update.find_each(batch_size: 300) do |user|
      UpdateUserWelcomeAppStatusService.call(user: user)
    end
  end
end
