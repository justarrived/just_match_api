# frozen_string_literal: true
class CreateJobApplicationService
  def self.call(job:, user:, attributes:, job_owner:)
    job_user = JobUser.find_or_initialize_by(user: user, job: job)
    job_user.application_withdrawn = false
    job_user.apply_message = attributes[:apply_message]
    job_user.language = Language.find_by(id: attributes[:language_id])

    if job_user.save
      job_user.set_translation(attributes).tap do |result|
        ProcessTranslationJob.perform_later(translation: result.translation)
      end

      missing_skills = job.skills - user.skills
      NewApplicantNotifier.call(
        job_user: job_user, owner: job_owner, skills: missing_skills
      )
    end

    job_user
  end
end
