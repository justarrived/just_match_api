# frozen_string_literal: true
class NewApplicantNotifier < BaseNotifier
  def self.call(job_user:, owner:, skills:)
    envelope = JobMailer.new_applicant_email(job_user: job_user, owner: owner)
    dispatch(envelope, user: owner, locale: owner.locale)

    user = job_user.user
    envelope = JobMailer.new_applicant_job_info_email(job_user: job_user, skills: skills)
    dispatch(envelope, user: user, locale: user.locale)
  end
end
