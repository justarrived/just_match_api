# frozen_string_literal: true

class FfInvoiceNumberToFrilansFinansInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :frilans_finans_invoices, :ff_invoice_number, :integer
  end
end
