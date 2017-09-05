# frozen_string_literal: true

class JobDigestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.active
    end
  end

  def index?
    true
  end

  alias_method :create?, :index?
  alias_method :update?, :index?
  alias_method :destroy?, :index?
end
