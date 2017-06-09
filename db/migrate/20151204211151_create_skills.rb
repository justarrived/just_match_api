# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[4.2]
  def change
    create_table :skills do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
