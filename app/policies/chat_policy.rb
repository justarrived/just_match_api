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
    user.admin?
  end
end
