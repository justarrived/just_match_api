# frozen_string_literal: true

class RatingPolicy < ApplicationPolicy
  Context = Struct.new(:current_user, :job)

  attr_reader :current_user, :job

  def initialize(context, record)
    @user = context.current_user
    @job = context.job
    @record = record
  end

  def create?
    Rating.user_allowed_to_rate?(user: user, job: job)
  end
end
