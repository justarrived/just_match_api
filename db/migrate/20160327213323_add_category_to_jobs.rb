# frozen_string_literal: true

class AddCategoryToJobs < ActiveRecord::Migration[4.2]
  def change
    add_reference :jobs, :category, index: true, foreign_key: true
  end
end
