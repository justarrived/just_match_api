# frozen_string_literal: true

class DropJobIndustriesTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :job_industries do |t|
      t.belongs_to :job, foreign_key: true
      t.belongs_to :industry, foreign_key: true

      t.integer :years_of_experience
      t.integer :importance

      t.timestamps
    end
  end
end
