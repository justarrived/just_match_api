# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class JobUserSeed < BaseSeed
    def self.call(jobs:, users:, languages:)
      max_job_users = max_count_opt('MAX_JOB_USERS', 100)

      log_seed(JobUser) do
        max_job_users.times do |current_iteration|
          job = jobs.sample
          owner = job.owner

          user = (users - [owner]).sample
          job_user = JobUser.find_or_create_by!(
            user: user,
            job: job
          )
          if (current_iteration % 3).zero?
            job_user.set_translation(
              apply_message: Faker::Hipster.paragraph(2),
              language: languages.sample
            )
          end
          # Accept one user as accepted applicant
          # if current_iteration == max_job_users - 1 && !job.accepted_applicant
          if !job.accepted_job_user && (current_iteration % 5).zero?
            job.accept_applicant!(user)
          end
        end
      end
    end
  end
end
