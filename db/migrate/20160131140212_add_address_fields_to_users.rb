# frozen_string_literal: true

class AddAddressFieldsToUsers < ActiveRecord::Migration
  def change
    # Remove old address column
    remove_column :users, :address, :string

    # Add separate address columns
    add_column :users, :street, :string
    add_column :users, :zip, :string
  end
end
