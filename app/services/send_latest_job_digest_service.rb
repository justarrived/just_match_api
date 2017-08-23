# frozen_string_literal: true

class SendLatestJobDigestService
  MAX_JOB_DIGEST_BATCH = 1000
  MAX_JOBS = 10

  def self.call(jobs_published_within_hours:, max_jobs: MAX_JOBS, job_digests_scope: JobDigest) # rubocop:disable Metrics/LineLength
    jobs = Job.with_translations.
           includes(:occupations).
           published.
           after(:publish_at, jobs_published_within_hours.hours.ago).
           limit(max_jobs)

    job_digests_scope.all.
      includes(:occupations, subscriber: %i(user)).
      find_in_batches(batch_size: MAX_JOB_DIGEST_BATCH) do |job_digests|

      SendJobDigestNotificationsService.call(
        jobs: jobs,
        job_digests: job_digests
      )
    end
  end
end
