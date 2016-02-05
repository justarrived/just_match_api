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

  def no_user?
    !user?
  end

  def user?
    !user.nil?
  end

  def admin_or_self?
    admin? || user == record
  end

  def admin?
    user? && user.admin?
  end
end
