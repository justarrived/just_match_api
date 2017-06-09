# frozen_string_literal: true

class AddZipCoordinatesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :zip_latitude, :float
    add_column :users, :zip_longitude, :float
  end
end
