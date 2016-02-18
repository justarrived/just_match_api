# frozen_string_literal: true
class SkillPolicy < ApplicationPolicy
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
