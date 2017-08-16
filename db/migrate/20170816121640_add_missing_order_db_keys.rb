# frozen_string_literal: true

class AddMissingOrderDbKeys < ActiveRecord::Migration[5.1]
  def change
    # rubocop:disable Metrics/LineLength
    add_foreign_key 'order_values', 'users', column: 'changed_by_user_id', name: 'order_values_changed_by_user_id_fk'
    add_foreign_key 'orders', 'users', column: 'delivery_user_id', name: 'orders_delivery_user_id_fk'
    add_foreign_key 'orders', 'users', column: 'sales_user_id', name: 'orders_sales_user_id_fk'
    # rubocop:enable Metrics/LineLength
  end
end
