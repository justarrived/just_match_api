class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
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

  def admin_or_self?
    user.admin? || user == record
  end
end
