# frozen_string_literal: true

class AddUsersToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :sales_user_id, :integer
    add_column :orders, :delivery_user_id, :integer

    add_index :orders, :sales_user_id
    add_index :orders, :delivery_user_id
  end
end
