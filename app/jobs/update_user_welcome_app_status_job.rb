# frozen_string_literal: true

class UpdateUserWelcomeAppStatusJob < ApplicationJob
  def perform(user:)
    UpdateUserWelcomeAppStatusService.call(user: user)
  end
end
