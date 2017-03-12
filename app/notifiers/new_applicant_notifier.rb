# frozen_string_literal: true
class NewApplicantNotifier < BaseNotifier
  def self.call(job_user:, owner:, skills:)
    notify(user: owner, locale: owner.locale) do
      JobMailer.
        new_applicant_email(job_user: job_user, owner: owner)
    end

    user = job_user.user
    notify(user: user, locale: user.locale) do
      JobMailer.new_applicant_job_info_email(job_user: job_user, skills: skills)
    end
  end
end
