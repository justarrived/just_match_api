# frozen_string_literal: true
class SkillPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.visible
    end
  end

  def index?
    true
  end

  alias_method :show?, :index?

  def create?
    admin?
  end

  alias_method :update?, :create?
  alias_method :destroy?, :create?
end
