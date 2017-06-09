# frozen_string_literal: true

class AddCancelledToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :cancelled, :boolean, default: false
  end
end
