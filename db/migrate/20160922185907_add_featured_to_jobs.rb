# frozen_string_literal: true

class AddFeaturedToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :featured, :boolean, default: false
  end
end
