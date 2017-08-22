# frozen_string_literal: true

class SendJobDigestNotificationsService
  def self.call(jobs:, job_digests:)
    job_digests.each do |job_digest|
      matching_jobs = jobs.select { |job| JobDigestMatch.match?(job, job_digest) }

      JobsDigestNotifier.call(
        jobs: matching_jobs,
        email: job_digest.email,
        user: job_digest.user
      )
    end
  end

  class JobDigestMatch
    def self.match?(*args)
      new(*args).match?
    end

    attr_reader :job, :job_digest

    def initialize(job, job_digest)
      @job = job
      @job_digest = job_digest
    end

    def match?
      return false unless city?
      return false unless occupations?

      true
    end

    def city?
      return true if job_digest.city.blank?
      return true if within_distance?

      false
    end

    def occupations?
      return true if job_digest.occupations.empty?

      (job.occupations & job_digest.occupations).any?
    end

    def within_distance?
      # fail(NotImplementedError, 'do it!')
      job.city == job_digest.city
    end
  end
end
