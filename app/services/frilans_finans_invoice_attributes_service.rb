# frozen_string_literal: true
class FrilansFinansInvoiceAttributesService
  def self.call(user:, job:, pre_report:, express_payment:, client: FrilansFinansApi.client_klass.new) # rubocop:disable Metrics/LineLength
    tax = FrilansFinansApi::Tax.index(only_standard: true, client: client).resource
    ff_user = FrilansFinansApi::User.show(id: user.frilans_finans_id!)

    # Build frilans finans invoice attributes
    FrilansFinans::InvoiceWrapper.attributes(
      job: job,
      user: user,
      tax: tax,
      ff_user: ff_user,
      pre_report: pre_report,
      express_payment: express_payment
    )
  end
end
