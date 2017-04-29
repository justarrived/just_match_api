# frozen_string_literal: true

class AddNumberToFillToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :number_to_fill, :integer, default: 1
  end
end
