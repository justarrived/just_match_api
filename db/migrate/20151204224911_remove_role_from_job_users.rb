class RemoveRoleFromJobUsers < ActiveRecord::Migration
  def change
    remove_column :job_users, :role, :integer
  end
end
