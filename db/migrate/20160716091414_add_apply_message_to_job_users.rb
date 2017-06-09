# frozen_string_literal: true

class AddApplyMessageToJobUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :job_users, :apply_message, :text
  end
end
