# frozen_string_literal: true
class AddAddressFieldsToJobs < ActiveRecord::Migration
  def change
    # Remove old address column
    remove_column :jobs, :address, :string

    # Add separate address columns
    add_column :jobs, :street, :string
    add_column :jobs, :zip, :string
  end
end
