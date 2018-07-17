# frozen_string_literal: true

class UpdateApplicantDataReminderNotifier < BaseNotifier
  def self.call(job_user:, skills:, languages:, occupations:, missing_cv:)
    user = job_user.user
    envelope = JobUserMailer.update_data_reminder_email(
      job_user: job_user,
      skills: skills,
      languages: languages,
      occupations: occupations,
      missing_cv: missing_cv
    )
    dispatch(envelope, user: user, locale: user.locale, name: 'update_data_reminder')
  end
end
