# frozen_string_literal: true

class AddWillPerformToJobUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :job_users, :will_perform, :boolean, default: false
  end
end
