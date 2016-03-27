# frozen_string_literal: true
module Queries
  class UserJobsFinder
    attr_reader :user, :job_user_filters

    def initialize(user, job_user_filters: {})
      @user = user
      @job_user_filters = job_user_filters
    end

    def perform
      return Job.none if user.nil?

      jobs = Job.associated_jobs(user)

      job_user_filters.each do |field_name, value|
        jobs = jobs.where("job_users.#{field_name}" => value) unless value.blank?
      end
      jobs
    end
  end
end
