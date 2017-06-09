# frozen_string_literal: true

class AddFilledToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :filled, :boolean, default: false
  end
end
