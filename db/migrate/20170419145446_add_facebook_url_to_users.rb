# frozen_string_literal: true

class AddFacebookUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_url, :string
  end
end
