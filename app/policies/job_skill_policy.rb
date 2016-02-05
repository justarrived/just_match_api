class JobSkillPolicy < ApplicationPolicy
  Context = Struct.new(:user, :job_context)

  attr_reader :job_context

  def initialize(user, record)
    @user = user.user
    @record = record
    @job_context = user.job_context
  end

  def index?
    true
  end

  alias_method :show?, :index?

  def create?
    admin? || job_context.owner == user
  end

  alias_method :destroy?, :create?
end
