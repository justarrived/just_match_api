class AddCancelledToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :cancelled, :boolean, default: false
  end
end
