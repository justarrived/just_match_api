# frozen_string_literal: true
module Sweepers
  class InvoiceSweeper
    def self.create_frilans_finans(scope = Invoice)
      scope.needs_frilans_finans_id.find_each(batch_size: 1000) do |invoice|
        CreateFrilansFinansInvoiceService.create(invoice: invoice)
      end
    end
  end
end
