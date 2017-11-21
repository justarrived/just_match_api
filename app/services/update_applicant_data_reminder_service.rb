# frozen_string_literal: true

class UpdateApplicantDataReminderService
  def self.call(job_user:)
    return if job_user.rejected?
    return if job_user.application_withdrawn?

    user = job_user.user
    job = job_user.job
    missing_traits = Queries::MissingUserTraits.new(user: user)
    skills = missing_traits.skills(skills: job.skills)
    languages = missing_traits.languages(languages: job.languages)
    occupations = missing_traits.occupations(occupations: job.occupations)
    missing_cv = missing_traits.cv?

    return if skills.empty? && occupations.empty? && languages.empty? && !missing_cv

    UpdateApplicantDataReminderNotifier.call(
      job_user: job_user,
      skills: skills,
      languages: languages,
      occupations: occupations,
      missing_cv: missing_cv
    )
  end
end
