# frozen_string_literal: true

class RemoveSkypeUsernameAndFacebookUrlFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :skype_username, :string
    remove_column :users, :facebook_url, :string
  end
end
