# frozen_string_literal: true

class SyncFrilansFinansInvoiceService
  def self.call(frilans_finans_invoice:, client: FrilansFinansAPI.config.client_klass.new)
    ff_id = frilans_finans_invoice.frilans_finans_id
    document = FrilansFinansAPI::Invoice.show(id: ff_id, client: client)
    ff_invoice = document.resource.attributes

    frilans_finans_invoice.ff_invoice_number = ff_invoice['invoice_number']
    frilans_finans_invoice.ff_payment_status = ff_invoice['payment_status']
    frilans_finans_invoice.ff_approval_status = ff_invoice['approval_status']
    frilans_finans_invoice.ff_status = ff_invoice['status']
    frilans_finans_invoice.ff_pre_report = ff_invoice['pre_report']
    frilans_finans_invoice.ff_amount = ff_invoice['amount']
    frilans_finans_invoice.ff_gross_salary = ff_invoice['gross']
    frilans_finans_invoice.ff_net_salary = ff_invoice['net']
    frilans_finans_invoice.ff_sent_at = ff_invoice['sent']
    frilans_finans_invoice.ff_last_synced_at = Time.zone.now
    frilans_finans_invoice.save!
  end
end
