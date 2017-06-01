# frozen_string_literal: true

class AddCategoryToJobs < ActiveRecord::Migration
  def change
    add_reference :jobs, :category, index: true, foreign_key: true
  end
end
