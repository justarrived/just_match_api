class ChatPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        user.chats
      end
    end
  end

  def index?
    admin?
  end

  private

  def admin?
    user? && user.admin?
  end

  def user?
    !user.nil?
  end
end
