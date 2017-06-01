# frozen_string_literal: true

class AddHiddenToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :hidden, :boolean, default: false
  end
end
