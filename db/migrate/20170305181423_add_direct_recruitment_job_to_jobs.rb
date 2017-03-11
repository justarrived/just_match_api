# frozen_string_literal: true
class AddDirectRecruitmentJobToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :direct_recruitment_job, :boolean, default: false
  end
end
