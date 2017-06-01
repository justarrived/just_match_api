# frozen_string_literal: true

class AddSkypeUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :skype_username, :string
  end
end
