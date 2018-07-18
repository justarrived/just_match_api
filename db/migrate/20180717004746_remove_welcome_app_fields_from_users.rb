# frozen_string_literal: true

class RemoveWelcomeAppFieldsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :has_welcome_app_account, :boolean
    remove_column :users, :welcome_app_last_checked_at, :datetime
  end
end
