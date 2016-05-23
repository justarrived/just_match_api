class AddActivatedToFrilansFinansInvoices < ActiveRecord::Migration
  def change
    add_column :frilans_finans_invoices, :activated, :boolean, default: false
  end
end
