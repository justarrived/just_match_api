class JobPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user?
  end

  def update?
    user?
  end

  def matching_users?
    user? && user.admin? || user == record.owner
  end

  private

  def user?
    !user.nil?
  end
end
