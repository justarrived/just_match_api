# frozen_string_literal: true

class CreateJobApplicationService
  def self.call(job_user:, attributes:, job_owner:)
    user = job_user.user
    job = job_user.job
    job_user.assign_attributes(attributes)
    job_user.application_withdrawn = false
    job_user.language = Language.find_by(id: attributes[:language_id])

    if job_user.save
      job_user.set_translation(attributes).tap do |result|
        ProcessTranslationJob.perform_later(
          translation: result.translation,
          changed: result.changed_fields
        )
      end

      missing_traits = Queries::MissingUserTraits.new(user: user)
      missing_skills = missing_traits.skills(skills: job.skills)
      missing_languages = missing_traits.languages(languages: job.languages)
      NewApplicantNotifier.call(
        job_user: job_user,
        owner: job_owner,
        skills: missing_skills,
        languages: missing_languages
      )
    end

    job_user
  end
end
