# frozen_string_literal: true

class AddBlocketjobbCategoryToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :blocketjobb_category, :string
  end
end
