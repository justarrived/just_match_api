# frozen_string_literal: true

class WithdrawJobApplicationService
  Response = Struct.new(:job_user, :errors)

  def self.call(job_owner:, job_user:)
    if job_user.will_perform
      errors = JsonApiErrors.new
      errors.add(detail: I18n.t('errors.job_user.will_perform_true_on_delete'))
      return Response.new(job_user, errors)
    end

    if job_user.accepted
      AcceptedApplicantWithdrawnNotifier.call(job_user: job_user, owner: job_owner)
    end

    job_user.application_withdrawn = true
    job_user.save
    Response.new(job_user, nil)
  end
end
