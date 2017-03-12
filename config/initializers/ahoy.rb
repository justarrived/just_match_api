# frozen_string_literal: true
module Ahoy
  class Store < Ahoy::Stores::ActiveRecordTokenStore
    def user
      return controller.true_user if controller.respond_to?(:true_user)
      controller.current_user if controller.respond_to?(:current_user)
    end
  end
end

Ahoy.api_only = true
