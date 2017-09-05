# frozen_string_literal: true

class SendWeeklyJobDigestNotifcationJob < ApplicationJob
  def perform
    SendLatestJobDigestService.call(
      jobs_published_within_hours: 24 * 7,
      job_digests: JobDigest.weekly
    )
  end
end
