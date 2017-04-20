class AddFilledAttributesToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :filled_hourly_pay_rate, :decimal
    add_column :orders, :filled_invoice_hourly_pay_rate, :decimal
    add_column :orders, :filled_hours, :decimal
  end
end
