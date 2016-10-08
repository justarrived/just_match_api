# frozen_string_literal: true
class CreateJobUserWillPerformService
  def self.call(job_user:)
    return job_user if job_user.will_perform

    job = job_user.job
    job_user.will_perform = true

    if job_user.save
      job.fill_position!
      # Frilans Finans wants invoices to be pre-reported
      FrilansFinansInvoice.create!(job_user: job_user)

      ApplicantWillPerformNotifier.call(job_user: job_user, owner: job.owner)
    end

    job_user
  end
end
