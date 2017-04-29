# frozen_string_literal: true

class AddCarRequiredToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :car_required, :boolean, default: false
  end
end
