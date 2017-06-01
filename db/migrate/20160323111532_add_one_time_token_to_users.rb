# frozen_string_literal: true

class AddOneTimeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :one_time_token, :string
    add_column :users, :one_time_token_expires_at, :datetime

    add_index :users, :one_time_token, unique: true
  end
end
