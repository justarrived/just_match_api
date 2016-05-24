# frozen_string_literal: true
module Sweepers
  class FrilansFinansInvoiceSweeper
    def self.create_frilans_finans(scope = FrilansFinansInvoice)
      scope.needs_frilans_finans_id.find_each(batch_size: 1000) do |ff_invoice|
        CreateFrilansFinansInvoiceService.create(ff_invoice: ff_invoice)
      end
    end

    def self.activate_frilans_finans(scope = Invoice)
      scope.needs_frilans_finans_activation.find_each(batch_size: 1000) do |invoice|
        ff_invoice = invoice.frilans_finans_invoice
        frilans_finans_id = ff_invoice.frilans_finans_id

        ff_invoice_remote = FrilansFinansApi::Invoice.update(
          id: frilans_finans_id,
          attributes: {
            invoice: {
              pre_report: false
            }
          }
        )

        frilans_finans_id_remote = ff_invoice_remote.resource.id.to_i

        # If the returned resource id isn't the same as the one returned from their API
        # either an error has occured or something has gone terribly wrong
        if frilans_finans_id == frilans_finans_id_remote
          ff_invoice.activated = true
          ff_invoice.save!
        else
          FailedToActivateInvoiceNotifier.call(ff_invoice: ff_invoice)
        end
      end
    end
  end
end
