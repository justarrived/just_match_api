class UserLanguagePolicy < ApplicationPolicy
  # User is the current user and user_context is the current user resource
  Context = Struct.new(:user, :user_context)

  attr_reader :user_context

  def initialize(user, record)
    @user = user.user
    @record = record
    @user_context = user.user_context
  end

  def index?
    admin? || user_context == user
  end

  alias_method :show?, :index?

  def create?
    admin_or_self?
  end

  alias_method :destroy?, :create?

  private

  def admin?
    user? && user.admin?
  end

  def user?
    !user.nil?
  end

  def admin_or_self?
    admin? || user == record.user
  end
end
