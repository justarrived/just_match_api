# frozen_string_literal: true

class SignJobUserService
  def self.call(**args)
    new(**args).call
  end

  attr_reader :job_user, :job_owner, :terms_agreement, :job, :user

  def initialize(job_user:, job_owner:, terms_agreement:)
    @job_user = job_user
    @job_owner = job_owner
    @terms_agreement = terms_agreement
    @job = job_user.job
    @user = job_user.user
  end

  def call
    job_user.will_perform = true
    return job_user unless job_user.save

    job.fill_position
    call_frilans_finans_actions

    ApplicantWillPerformNotifier.call(job_user: job_user, owner: job_owner)
    ExecuteService.call(SendApplicantRejectNotificationsService, job_user)

    # Reject all other job users
    job_users.update_all(rejected: true) # rubocop:disable Rails/SkipsModelValidations

    job_user
  end

  def call_frilans_finans_actions
    return unless job.frilans_finans_job?

    TermsAgreementConsent.create!(
      terms_agreement: terms_agreement,
      user: user,
      job: job
    )

    FrilansFinansInvoice.create!(job_user: job_user)
  end
end
