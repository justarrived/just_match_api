# frozen_string_literal: true
class AddZipCoordinatesToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :zip_latitude, :float
    add_column :jobs, :zip_longitude, :float
  end
end
