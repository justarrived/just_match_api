# frozen_string_literal: true

class SendJobDigestNotificationsService
  def self.call(jobs:, job_digests:, max_jobs: AppConfig.max_jobs_in_digest_notification)
    total_sent = 0
    job_digests.each do |job_digest|
      matching_jobs = jobs.select { |job| JobDigestMatch.match?(job, job_digest) }
      next if matching_jobs.empty?

      JobsDigestNotifier.call(jobs: matching_jobs[0...max_jobs], job_digest: job_digest)
      data = {
        user_id: job_digest.user_id,
        email: job_digest.email,
        job_digest_id: job_digest.id,
        matching_job_ids: matching_jobs.map(&:id)
      }
      Analytics.track(:sent_job_digest_email, data: data)

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
      return true if job_digest.addresses.empty?

      job_digest.addresses.each do |address|
        return true unless address.coordinates?
        return true if within_distance?(address)
      end

      false
    end

    def occupations?
      return true if job_digest.occupations.empty?
      return false if job.occupations.empty?

      job_digest_occupations = occupation_root_ids(job_digest.occupations)
      job_occupations = occupation_root_ids(job.occupations)

      (job_occupations & job_digest_occupations).any?
    end

    def within_distance?(address)
      return false unless job.latitude
      return false unless job.longitude

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
