# frozen_string_literal: true

class AddFfFieldsToFrilansFinansInvoice < ActiveRecord::Migration[5.0]
  def change
    add_column :frilans_finans_invoices, :ff_pre_report, :boolean, default: true
    add_column :frilans_finans_invoices, :ff_amount, :float
    add_column :frilans_finans_invoices, :ff_gross_salary, :float
    add_column :frilans_finans_invoices, :ff_net_salary, :float
    add_column :frilans_finans_invoices, :ff_payment_status, :integer
    add_column :frilans_finans_invoices, :ff_approval_status, :integer
    add_column :frilans_finans_invoices, :ff_status, :integer
    add_column :frilans_finans_invoices, :ff_sent_at, :datetime
  end
end
