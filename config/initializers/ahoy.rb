# frozen_string_literal: true

module Ahoy
  class Store < DatabaseStore
    def user
      return if controller.nil?
      return controller.true_user if controller.respond_to?(:true_user)
      controller.current_user if controller.respond_to?(:current_user)
    end
  end
end

Ahoy.api = true
Ahoy.server_side_visits = :when_needed
Ahoy.geocode = :async
Ahoy.protect_from_forgery = false
