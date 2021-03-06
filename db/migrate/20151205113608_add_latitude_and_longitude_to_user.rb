# frozen_string_literal: true

class AddLatitudeAndLongitudeToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :address, :string
  end
end
