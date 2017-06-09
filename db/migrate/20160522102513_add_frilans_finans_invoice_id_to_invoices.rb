# frozen_string_literal: true

class AddFrilansFinansInvoiceIdToInvoices < ActiveRecord::Migration[4.2]
  def change
    add_reference :invoices, :frilans_finans_invoice, index: true, foreign_key: true
  end
end
