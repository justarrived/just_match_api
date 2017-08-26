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
      return false if job.occupations.empty?

      job_digest_occupations = occupation_root_ids(job_digest.occupations)
      job_occupations = occupation_root_ids(job.occupations)

      (job_occupations & job_digest_occupations).any?
    end

    def within_distance?
      # TODO: Implement lat/long comparision
      job.city == job_digest.city
    end

    def occupation_root_ids(occupations)
      occupations.map do |job_digest|
        (job_digest.ancestry.presence || job_digest.id).to_s
      end.uniq
    end
  end
end
