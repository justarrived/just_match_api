# frozen_string_literal: true

class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.string :name
      t.belongs_to :language, foreign_key: true
      t.boolean :internal, default: false

      t.timestamps
    end
  end
end
