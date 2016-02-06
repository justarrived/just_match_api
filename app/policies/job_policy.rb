class JobPolicy < ApplicationPolicy
  def index?
    true
  end

  alias_method :show?, :index?

  def create?
    user?
  end

  alias_method :update?, :create?

  def matching_users?
    admin? || user == record.owner
  end
end
