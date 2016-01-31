class AddZipCoordinatesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip_latitude, :float
    add_column :users, :zip_longitude, :float
  end
end
