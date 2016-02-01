class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    no_user? || admin?
  end

  def show?
    admin_or_self?
  end

  def update?
    admin_or_self?
  end

  def destroy?
    admin_or_self?
  end

  def matching_jobs?
    admin_or_self?
  end

  def jobs?
    admin_or_self?
  end

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
