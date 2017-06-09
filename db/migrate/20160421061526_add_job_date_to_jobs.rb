# frozen_string_literal: true

class AddJobDateToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :job_end_date, :datetime
  end
end
