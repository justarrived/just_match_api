# frozen_string_literal: true

class AddExpressPaymentToFrilansFinansInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :frilans_finans_invoices, :express_payment, :boolean, default: false
  end
end
