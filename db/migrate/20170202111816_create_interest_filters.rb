# frozen_string_literal: true

class CreateInterestFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :interest_filters do |t|
      t.belongs_to :filter, foreign_key: true
      t.belongs_to :interest, foreign_key: true
      t.integer :level
      t.integer :level_by_admin

      t.timestamps
    end
  end
end
