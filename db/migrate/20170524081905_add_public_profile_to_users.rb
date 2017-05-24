# frozen_string_literal: true

class AddPublicProfileToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :public_profile, :boolean, default: false
  end
end
