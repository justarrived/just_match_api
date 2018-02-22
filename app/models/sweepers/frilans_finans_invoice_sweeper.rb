# frozen_string_literal: true

module Sweepers
  class FrilansFinansInvoiceSweeper
    def self.create_frilans_finans(scope = FrilansFinansInvoice)
      scope.needs_frilans_finans_id.find_each(batch_size: 500) do |ff_invoice|
        begin
          CreateFrilansFinansInvoiceService.create(ff_invoice: ff_invoice)
        rescue User::MissingFrilansFinansIdError => e
          ErrorNotifier.send(e, context: { frilans_finans_invoice_id: ff_invoice.id })
        end
      end
    end

    def self.activate_frilans_finans(scope = Invoice)
      scope.needs_frilans_finans_activation.find_each(batch_size: 500) do |invoice|
        ff_invoice = invoice.frilans_finans_invoice
        frilans_finans_id = ff_invoice.frilans_finans_id

        attributes = FrilansFinansInvoiceAttributesService.call(
          user: invoice.user,
          job: invoice.job,
          pre_report: false,
          express_payment: ff_invoice.express_payment
        )

        ff_invoice_remote = FrilansFinansAPI::Invoice.update(
          id: frilans_finans_id,
          attributes: attributes
        )

        frilans_finans_id_remote = ff_invoice_remote.resource.id.to_i

        # If the returned resource id isn't the same as the one returned from their API
        # either an error has occured or something has gone terribly wrong
        if frilans_finans_id == frilans_finans_id_remote
          # Perhaps we should send a notification to the job user, that the invoice has
          # been created/activated (perhaps to the job owner too)
          ff_invoice.activated = true
          ff_invoice.save!
        else
          Rails.logger.info "Frilans Finans invoice id missmatch: local ff id: '#{frilans_finans_id}', remote ff id: '#{frilans_finans_id_remote}'" # rubocop:disable Metrics/LineLength
          FailedToActivateInvoiceNotifier.call(ff_invoice: ff_invoice)
        end
      end
    end

    def self.remote_sync(scope = FrilansFinansInvoice)
      scope.has_frilans_finans_id.not_paid.find_each(batch_size: 500) do |ff_invoice|
        SyncFrilansFinansInvoiceService.call(frilans_finans_invoice: ff_invoice)
      end
    end
  end
end
