# frozen_string_literal: true
class AddSsykToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :ssyk, :integer
  end
end
