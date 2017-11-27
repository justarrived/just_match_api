# frozen_string_literal: true

class SignJobUserService
  def self.call(**args)
    new(**args).call
  end

  attr_reader :job_user, :job_owner, :terms_agreement

  def initialize(job_user:, job_owner:, terms_agreement:)
    @job_user = job_user
    @job_owner = job_owner
    @terms_agreement = terms_agreement
  end

  def call
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
    reject_non_accepted_applicants(job_user)

    job_user
  end

  def reject_non_accepted_applicants(signed_job_user)
    job_users = signed_job_user.job.
                job_users.
                not_accepted.
                not_withdrawn.
                unrejected.
                includes(:user)

    job_users.each do |job_user|
      next if signed_job_user == job_user

      ApplicantRejectedNotifier.call(job_user: job_user)
    end

    # Reject all other job users
    job_users.update_all(rejected: true) # rubocop:disable Rails/SkipsModelValidations
    job_users
  end
end
