# frozen_string_literal: true

class AddFilledToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :filled, :boolean, default: false
  end
end
