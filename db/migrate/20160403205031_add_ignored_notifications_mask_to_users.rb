# frozen_string_literal: true

class AddIgnoredNotificationsMaskToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :ignored_notifications_mask, :integer
  end
end
