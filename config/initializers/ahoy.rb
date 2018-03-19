# frozen_string_literal: true

class Ahoy::Store < Ahoy::DatabaseStore
  def visit_model
    Visit
  end

  def user
    return if controller.nil?
    return controller.true_user if controller.respond_to?(:true_user)
    controller.current_user if controller.respond_to?(:current_user)
  end
end

Ahoy.api = true
Ahoy.server_side_visits = :when_needed
Ahoy.geocode = :async
