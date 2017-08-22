# frozen_string_literal: true

class SendLatestJobDigestService
  def self.call(jobs_published_within_hours:)
    jobs = Job.with_translations.
           includes(:occupations).
           published.
           after(:publish_at, jobs_published_within_hours.hours.ago)

    JobDigests.
      includes(:occupations, subscriber: %i(user)).
      find_in_batches(batch_size: 1000) do |job_digests|

      SendJobDigestNotificationsService.call(
        jobs: jobs,
        job_digests: job_digests
      )
    end
  end
end
