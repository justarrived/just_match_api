# frozen_string_literal: true
class JobUserPolicy < ApplicationPolicy
  Context = Struct.new(:user, :job_context, :user_record)

  attr_reader :job_context, :user_record

  def initialize(user, record)
    @user = user.user
    @record = record
    @job_context = user.job_context
    @user_record = user.user_record
  end

  def index?
    admin? || job_context.owner == user
  end

  def create?
    user?
  end

  def show?
    admin? || job_context.owner == user || user_record == user
  end

  alias_method :update?, :index?

  def destroy?
    admin? || user_record == user
  end
end
