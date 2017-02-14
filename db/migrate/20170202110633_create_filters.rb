# frozen_string_literal: true
class CreateFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :filters do |t|
      t.string :name

      t.timestamps
    end
  end
end
