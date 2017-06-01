# frozen_string_literal: true

class AddStaffingJobToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :staffing_job, :boolean, default: false
  end
end
