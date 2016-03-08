# frozen_string_literal: true
require 'seeds/dev/base_seed'

class JobUserSeed < BaseSeed
  def self.call(jobs:, users:)
    max_job_users = max_count_opt('MAX_JOB_USERS', 10)

    log '[db:seed] Job user'
    max_job_users.times do |current_iteration|
      job = jobs.sample
      owner = job.owner

      user = users.sample
      max_retries = 5
      until owner != user
        user = users.sample
        max_retries += 1
        break if max_retries < 1
      end

      job = jobs.sample
      JobUser.create(
        user: user,
        job: job
      )
      # Accept one user as accepted applicant
      if current_iteration == max_job_users - 1
        job.accept_applicant!(user)
      end
    end
  end
end
