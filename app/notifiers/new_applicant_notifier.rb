class NewApplicantNotifier
  # TODO: Actually send a notification
  def self.call(job_user)
    job = job_user.job
    user = job_user.user
    owner = job.owner

    name = owner.name
    user_email = job_user.job.owner.email

    message = "Congrats #{name}! You've recieved a new job application. "
    message << "You can contact #{user_email}, for more details."
    Rails.logger.debug { "NOTIFY: #{message}" }
  end
end
