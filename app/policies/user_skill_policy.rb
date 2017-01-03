# frozen_string_literal: true
class UserSkillPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.visible
    end
  end

  Context = Struct.new(:user, :user_record)

  attr_reader :user_record

  def initialize(user, record)
    @user = user.user
    @record = record
    @user_record = user.user_record
  end

  def index?
    admin? || user_record == user
  end

  alias_method :show?, :index?

  def create?
    admin_or_self?
  end

  alias_method :destroy?, :create?

  private

  def admin_or_self?
    admin? || user == record.user
  end
end
