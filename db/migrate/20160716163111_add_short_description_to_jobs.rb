# frozen_string_literal: true
class AddShortDescriptionToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :short_description, :string
  end
end
