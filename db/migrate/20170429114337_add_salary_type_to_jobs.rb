# frozen_string_literal: true

class AddSalaryTypeToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :salary_type, :integer, default: 1 # 1 == fixed salary type
  end
end
