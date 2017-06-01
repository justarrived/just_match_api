# frozen_string_literal: true

class AddFeaturedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :featured, :boolean, default: false
  end
end
