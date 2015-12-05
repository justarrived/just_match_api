class AddLatitudeAndLongitudeToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :latitude, :float
    add_column :jobs, :longitude, :float
    add_column :jobs, :address, :string
  end
end
