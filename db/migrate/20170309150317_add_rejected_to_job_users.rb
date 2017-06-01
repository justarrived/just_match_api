# frozen_string_literal: true

class AddRejectedToJobUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :job_users, :rejected, :boolean, default: false
  end
end
