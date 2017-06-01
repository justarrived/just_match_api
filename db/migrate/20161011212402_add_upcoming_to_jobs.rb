# frozen_string_literal: true

class AddUpcomingToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :upcoming, :boolean, default: false
  end
end
