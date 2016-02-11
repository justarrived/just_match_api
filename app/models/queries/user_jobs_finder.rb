# frozen_string_literal: true
module Queries
  class UserJobsFinder
    def initialize(user)
      @user = user
    end

    def perform
      return Job.none if @user.nil?

      @user.jobs + @user.owned_jobs
    end
  end
end
