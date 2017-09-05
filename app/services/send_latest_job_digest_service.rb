# frozen_string_literal: true

class SendLatestJobDigestService
  MAX_JOB_DIGEST_BATCH = 1000

  def self.call(jobs_published_within_hours:, job_digests_scope: JobDigest)
    jobs = Job.with_translations.
           includes(:occupations).
           published.
           after(:publish_at, jobs_published_within_hours.hours.ago)

    total_sent = 0
    job_digests_scope.active.
      includes(:occupations, :address, subscriber: %i(user)).
      find_in_batches(batch_size: MAX_JOB_DIGEST_BATCH) do |job_digests|
      total_sent += SendJobDigestNotificationsService.call(
        jobs: jobs,
        job_digests: job_digests
      )
    end
    total_sent
  end
end
