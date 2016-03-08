# frozen_string_literal: true
class JobUserPolicy < ApplicationPolicy
  Context = Struct.new(:user, :job_context, :user_record)

  JOB_OWNER_ATTRIBUTES = [:accepted].freeze
  JOB_USER_ATTRIBUTES = [:will_perform].freeze
  ADMIN_ATTRIBUTES = JOB_OWNER_ATTRIBUTES + JOB_USER_ATTRIBUTES

  attr_reader :job_context, :user_record

  def initialize(user, record)
    @user = user.user
    @record = record
    @job_context = user.job_context
    @user_record = user.user_record
  end

  def index?
    admin? || job_owner?
  end

  def create?
    user?
  end

  def show?
    admin? || job_owner? || job_user?
  end

  alias_method :update?, :show?

  def destroy?
    admin? || job_user?
  end

  def permitted_attributes
    if admin?
      ADMIN_ATTRIBUTES
    elsif job_owner?
      JOB_OWNER_ATTRIBUTES
    elsif job_user?
      JOB_USER_ATTRIBUTES
    else
      []
    end
  end

  private

  def job_user?
    user_record == user
  end

  def job_owner?
    job_context.owner == user
  end
end
