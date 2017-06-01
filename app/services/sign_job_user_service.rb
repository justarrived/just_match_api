# frozen_string_literal: true

class SignJobUserService
  def self.call(job_user:, job_owner:, terms_agreement:)
    job_user.will_perform = true
    return job_user unless job_user.save

    job = job_user.job
    user = job_user.user

    TermsAgreementConsent.create!(
      terms_agreement: terms_agreement,
      user: user,
      job: job
    )

    job.fill_position

    if job.frilans_finans_job?
      # Frilans Finans wants invoices to be pre-reported
      FrilansFinansInvoice.create!(job_user: job_user)
    end

    ApplicantWillPerformNotifier.call(job_user: job_user, owner: job_owner)

    job_user
  end
end
