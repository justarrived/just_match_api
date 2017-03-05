# frozen_string_literal: true
class CreateJobApplicationService
  def self.call(job:, user:, attributes:, notify_users: [])
    job_user = JobUser.new
    job_user.user = user
    job_user.job = job

    job_user.apply_message = attributes[:apply_message]
    job_user.language = Language.find_by(id: attributes[:language_id])

    if job_user.save
      job_user.set_translation(attributes).tap do |result|
        EnqueueCheapTranslation.call(result)
      end

      notify_users.each do |owner|
        NewApplicantNotifier.call(job_user: job_user, owner: owner)
      end
    end

    job_user
  end
end
