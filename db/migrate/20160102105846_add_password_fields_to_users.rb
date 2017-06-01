# frozen_string_literal: true

class AddPasswordFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
  end
end
