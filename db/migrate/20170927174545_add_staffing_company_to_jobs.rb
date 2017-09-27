# frozen_string_literal: true

class AddStaffingCompanyToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :staffing_company_id, :integer
    add_index :jobs, :staffing_company_id
  end
end
