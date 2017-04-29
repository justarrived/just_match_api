# frozen_string_literal: true

class AddMunicipalityToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :municipality, :string
  end
end
