# frozen_string_literal: true
class FrilansFinansInvoiceAttributesService
  def self.call(user:, job:, pre_report:, client: FrilansFinansApi.client_klass.new)
    tax = FrilansFinansApi::Tax.index(only_standard: true, client: client).resource

    # We need to update the users profession title to match the jobs,
    # in order to please Frilans Finans
    ff_user = FrilansFinansApi::User.update(
      id: user.frilans_finans_id!,
      attributes: { profession_title: job.category.name }
    )

    # Build frilans finans invoice attributes
    FrilansFinans::InvoiceWrapper.attributes(
      job: job,
      user: user,
      tax: tax,
      ff_user: ff_user,
      pre_report: pre_report
    )
  end
end
