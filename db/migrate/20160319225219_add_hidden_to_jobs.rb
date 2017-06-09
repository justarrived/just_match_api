# frozen_string_literal: true

class AddHiddenToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :hidden, :boolean, default: false
  end
end
