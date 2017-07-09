# frozen_string_literal: true

class CreateOrderValues < ActiveRecord::Migration[5.1]
  def change
    create_table :order_values do |t|
      t.belongs_to :order, foreign_key: true
      t.integer :previous_order_value_id

      t.text :change_comment
      t.integer :change_reason_category

      t.decimal :total_sold
      t.decimal :sold_hourly_salary
      t.decimal :sold_hourly_price
      t.decimal :sold_hours_per_month
      t.decimal :sold_number_of_months

      t.decimal :total_filled
      t.decimal :filled_hourly_salary
      t.decimal :filled_hourly_price
      t.decimal :filled_hours_per_month
      t.decimal :filled_number_of_months

      t.timestamps
    end

    add_foreign_key 'order_values', 'order_values', column: 'previous_order_value_id', name: 'previous_order_value_id_fk' # rubocop:disable Metrics/LineLength
  end
end
