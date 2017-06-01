# frozen_string_literal: true

class AddJobDateToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :job_end_date, :datetime
  end
end
