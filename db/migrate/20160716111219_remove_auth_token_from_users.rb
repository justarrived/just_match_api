# frozen_string_literal: true

class RemoveAuthTokenFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :auth_token, :string
  end
end
