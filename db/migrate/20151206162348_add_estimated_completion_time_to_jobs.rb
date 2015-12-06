class AddEstimatedCompletionTimeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :estimated_completion_time, :float
  end
end
