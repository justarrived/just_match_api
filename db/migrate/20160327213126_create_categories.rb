# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :categories, :name, unique: true
  end
end
