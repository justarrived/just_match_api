# frozen_string_literal: true

class AddFrilansFinansInvoiceIdToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :frilans_finans_invoice, index: true, foreign_key: true
  end
end
