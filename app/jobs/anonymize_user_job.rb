# frozen_string_literal: true

class AnonymizeUserJob < ApplicationJob
  def perform(user)
    AnonymizeUserService.call(user)
  end
end
