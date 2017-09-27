# frozen_string_literal: true

class AddPreviousOrderIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :previous_order_id, :integer
    add_index :orders, :previous_order_id
  end
end
