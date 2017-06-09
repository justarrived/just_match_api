# frozen_string_literal: true

class AddGrossSalaryToHourlyPays < ActiveRecord::Migration[4.2]
  def change
    add_column :hourly_pays, :gross_salary, :integer
  end
end
