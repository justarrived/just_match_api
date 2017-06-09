# frozen_string_literal: true

class AddManagedToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :managed, :boolean, default: false
  end
end
