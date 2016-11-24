# frozen_string_literal: true
class AddAccountDetailsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :account_clearing_number, :string
    add_column :users, :account_number, :string
  end
end
