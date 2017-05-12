# frozen_string_literal: true

class AddWelcomeAppFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_welcome_app_account, :boolean, default: false
    add_column :users, :welcome_app_last_checked_at, :datetime
  end
end
