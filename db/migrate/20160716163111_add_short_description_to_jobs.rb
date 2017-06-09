# frozen_string_literal: true

class AddShortDescriptionToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :short_description, :string
  end
end
