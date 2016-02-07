class JobUserPolicy < ApplicationPolicy
  Context = Struct.new(:user, :job_context, :user_context)

  attr_reader :job_context, :user_context

  def initialize(user, record)
    @user = user.user
    @record = record
    @job_context = user.job_context
    @user_context = user.user_context
  end

  def index?
    admin? || job_context.owner == user
  end

  def create?
    user?
  end

  def show?
    admin? || job_context.owner == user || user_context == user
  end

  alias_method :update?, :index?

  def destroy?
    admin? || user_context == user
  end
end
