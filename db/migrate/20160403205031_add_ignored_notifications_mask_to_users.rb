# frozen_string_literal: true

class AddIgnoredNotificationsMaskToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ignored_notifications_mask, :integer
  end
end
