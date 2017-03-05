# frozen_string_literal: true
class SignJobUserService
  def self.call(job_user:, job_owner:)
    job_user.will_perform = true

    if job_user.save
      job_user.job.fill_position

      # TODO: Only create this is its a Frilans Finans job
      # Frilans Finans wants invoices to be pre-reported
      FrilansFinansInvoice.create!(job_user: job_user)

      ApplicantWillPerformNotifier.call(job_user: job_user, owner: job_owner)
    end

    job_user
  end
end
