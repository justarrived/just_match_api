# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.belongs_to :job_request, foreign_key: true
      t.decimal :invoice_hourly_pay_rate
      t.decimal :hourly_pay_rate
      t.decimal :hours
      t.boolean :lost, default: false

      t.timestamps
    end
  end
end
