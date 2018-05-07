# frozen_string_literal: true

class AddFfRemoteIdToFrilansFinansInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :frilans_finans_invoices, :ff_remote_id, :string
  end
end
