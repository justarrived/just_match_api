# frozen_string_literal: true

class RemoveMaxRateFromJobs < ActiveRecord::Migration[4.2]
  def change
    remove_column :jobs, :max_rate, :integer
  end
end
