# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :color
      t.string :name

      t.timestamps
    end
  end
end
