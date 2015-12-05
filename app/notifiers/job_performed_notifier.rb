class JobPerformedNotifier
  # TODO: Actually send a notification
  def self.call(job)
    owner = job.owner
    user = job.job_user.user

    message = "Congrats #{user.name}! Its been verified that you've performed a job for #{owner.name}! "
    Rails.logger.debug { "NOTIFY: #{message}" }
  end
end
