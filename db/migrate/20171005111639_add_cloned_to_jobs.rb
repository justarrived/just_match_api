# frozen_string_literal: true

class AddClonedToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :cloned, :boolean, default: false
  end
end
