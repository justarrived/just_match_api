# frozen_string_literal: true

class AddPasswordFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
  end
end
