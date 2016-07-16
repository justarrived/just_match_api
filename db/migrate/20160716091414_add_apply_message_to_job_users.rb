# frozen_string_literal: true
class AddApplyMessageToJobUsers < ActiveRecord::Migration
  def change
    add_column :job_users, :apply_message, :text
  end
end
