# frozen_string_literal: true
module Sweepers
  class InvoiceSweeper
    def self.create_frilans_finans(scope = FrilansFinansInvoice)
      scope.needs_frilans_finans_id.find_each(batch_size: 1000) do |ff_invoice|
        CreateFrilansFinansInvoiceService.create(ff_invoice: ff_invoice)
      end
    end
  end
end
