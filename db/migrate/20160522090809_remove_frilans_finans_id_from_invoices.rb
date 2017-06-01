# frozen_string_literal: true

class RemoveFrilansFinansIdFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :frilans_finans_id, :integer
  end
end
