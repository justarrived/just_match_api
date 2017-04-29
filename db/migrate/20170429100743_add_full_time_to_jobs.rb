# frozen_string_literal: true

class AddFullTimeToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :full_time, :boolean, default: false
  end
end
