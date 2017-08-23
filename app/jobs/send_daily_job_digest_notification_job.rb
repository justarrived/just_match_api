# frozen_string_literal: true

class SendDailyJobDigestNotifcationJob < ApplicationJob
  def perform
    SendLatestJobDigestService.call(
      jobs_published_within_hours: 24,
      job_digests: JobDigest.daily
    )
  end
end
