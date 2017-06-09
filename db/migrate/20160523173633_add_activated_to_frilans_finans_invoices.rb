# frozen_string_literal: true

class AddActivatedToFrilansFinansInvoices < ActiveRecord::Migration[4.2]
  def change
    add_column :frilans_finans_invoices, :activated, :boolean, default: false
  end
end
