# frozen_string_literal: true

class NewApplicantNotifierJob < ApplicationJob
  def perform(job_user:)
    user = job_user.user
    job = job_user.job

    missing_traits = Queries::MissingUserTraits.new(user: user)
    missing_skills = missing_traits.skills(skills: job.skills)
    missing_languages = missing_traits.languages(languages: job.languages)
    missing_cv = missing_traits.cv?

    NewApplicantNotifier.call(
      job_user: job_user,
      owner: job.owner,
      skills: missing_skills,
      languages: missing_languages,
      missing_cv: missing_cv
    )
  end
end
