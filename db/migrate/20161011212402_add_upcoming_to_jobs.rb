# frozen_string_literal: true

class AddUpcomingToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :upcoming, :boolean, default: false
  end
end
