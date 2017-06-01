# frozen_string_literal: true

class AddGrossSalaryToHourlyPays < ActiveRecord::Migration
  def change
    add_column :hourly_pays, :gross_salary, :integer
  end
end
