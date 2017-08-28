# frozen_string_literal: true

class SendJobDigestNotificationsService
  def self.call(jobs:, job_digests:)
    total_sent = 0
    job_digests.each do |job_digest|
      matching_jobs = jobs.select { |job| JobDigestMatch.match?(job, job_digest) }
      next if matching_jobs.empty?

      JobsDigestNotifier.call(jobs: matching_jobs, job_digest: job_digest)
      total_sent += 1
    end
    total_sent
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
      return false unless address?
      return false unless occupations?

      true
    end

    def address?
      return true unless job_digest.address
      return true unless job_digest.address.coordinates?
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
      return false unless job.latitude
      return false unless job.longitude

      address = job_digest.address

      distance = Geocoder::Calculations.distance_between(
        [job.latitude, job.longitude],
        [address.latitude, address.longitude]
      )
      distance < job_digest.max_distance
    end

    def occupation_root_ids(occupations)
      occupations.map do |job_digest|
        (job_digest.ancestry.presence || job_digest.id).to_s
      end.uniq
    end
  end
end
