# frozen_string_literal: true
class NewApplicantNotifier < BaseNotifier
  def self.call(job_user:, owner:, skills:, languages:)
    envelope = JobMailer.new_applicant_email(job_user: job_user, owner: owner)
    dispatch(envelope, user: owner, locale: owner.locale)

    user = job_user.user
    envelope = JobUserMailer.new_applicant_job_info_email(
      job_user: job_user, skills: skills, languages: languages
    )
    dispatch(envelope, user: user, locale: user.locale)
  end
end
