# frozen_string_literal: true

class AddPerformedAndPerformAcceptToJobUsers < ActiveRecord::Migration
  def change
    add_column :job_users, :performed, :boolean, default: false
    add_column :job_users, :performed_accepted, :boolean, default: false
  end
end
