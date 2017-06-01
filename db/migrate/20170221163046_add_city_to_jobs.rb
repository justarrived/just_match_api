# frozen_string_literal: true

class AddCityToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :city, :string
  end
end
