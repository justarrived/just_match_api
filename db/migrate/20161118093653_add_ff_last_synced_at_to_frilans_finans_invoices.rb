# frozen_string_literal: true
class AddFfLastSyncedAtToFrilansFinansInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :frilans_finans_invoices, :ff_last_synced_at, :datetime
  end
end
