# frozen_string_literal: true

class AddPercentageToEmploymentPeriod < ActiveRecord::Migration[5.1]
  def change
    add_column :employment_periods, :percentage, :decimal
  end
end
