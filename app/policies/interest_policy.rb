# frozen_string_literal: true

class InterestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.visible
    end
  end

  def index?
    true
  end

  alias_method :show?, :index?
end
