class ApplicantAcceptedNotifier
  # TODO: Actually send a notification
  def self.call(job_user)
    name = job_user.user.name
    owner_email = job_user.job.owner.email

    message = "Congrats #{name}! You've been accepted for a job! "
    message << "You can contact #{owner_email}, for more details."
    Rails.logger.debug { "NOTIFY: #{message}" }
  end
end
