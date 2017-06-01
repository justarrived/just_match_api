# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :max_rate
      t.text :description
      t.datetime :job_date
      t.boolean :performed_accept, default: false
      t.boolean :performed, default: false
      t.float :hours
      t.string :name

      t.timestamps null: false
    end
  end
end
