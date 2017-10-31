# frozen_string_literal: true

module Ahoy
  class EventPolicy < ApplicationPolicy
    def create?
      true
    end
  end
end
