# frozen_string_literal: true
class AddShortlistedToJobUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :job_users, :shortlisted, :boolean, default: false
  end
end
