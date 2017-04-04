# frozen_string_literal: true
class JobUserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.visible
    end
  end

  Context = Struct.new(:current_user, :job_context, :user_record)

  JOB_OWNER_ATTRIBUTES = [:accepted].freeze
  JOB_USER_ATTRIBUTES = [:will_perform, :performed, :apply_message, :language_id].freeze
  ADMIN_ATTRIBUTES = JOB_OWNER_ATTRIBUTES + JOB_USER_ATTRIBUTES

  attr_reader :job_context, :user_record

  def initialize(user, record)
    @user = user.current_user
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

  def accepted?
    admin? || job_owner?
  end

  def confirmation?
    admin? || job_user?
  end

  def performed?
    admin? || job_user?
  end

  def permitted_attributes
    return [] if no_user?
    return ADMIN_ATTRIBUTES if admin?
    return JOB_OWNER_ATTRIBUTES if job_owner?
    return JOB_USER_ATTRIBUTES unless record&.persisted?

    if job_user?
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
