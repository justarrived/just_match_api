# frozen_string_literal: true
class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    true
  end

  def show?
    admin_or_self?
  end

  alias_method :update?, :show?
  alias_method :destroy?, :show?
  alias_method :matching_jobs?, :show?
  alias_method :jobs?, :show?

  private

  def admin_or_self?
    admin? || user == record
  end
end
