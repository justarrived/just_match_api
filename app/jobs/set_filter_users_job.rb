# frozen_string_literal: true
class SetFilterUsersJob < ApplicationJob
  def perform(filter:)
    SetFilterUsersService.call(filter: filter)
  end
end
