# frozen_string_literal: true
class AskForJobInformationNotifier < BaseNotifier
  def self.call(job_user:)
    job = job_user.job
    user = job_user.user
    missing_skills = job.skills - user.skills

    return if missing_skills.empty?

    notify(user: user, locale: user.locale) do
      JobMailer.
        ask_for_information_email(user: user, job: job, skills: missing_skills)
    end
  end
end
