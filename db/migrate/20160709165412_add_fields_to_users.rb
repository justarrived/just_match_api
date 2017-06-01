# frozen_string_literal: true

class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_status, :integer
    add_column :users, :at_und, :integer
    add_column :users, :arrived_at, :date
    add_column :users, :country_of_origin, :string
  end
end
