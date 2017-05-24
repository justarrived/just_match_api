# frozen_string_literal: true

class AddAdditionalFieldsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :name, :string
    add_column :orders, :category, :integer
  end
end
