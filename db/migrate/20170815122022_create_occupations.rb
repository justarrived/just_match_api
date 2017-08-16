# frozen_string_literal: true

class CreateOccupations < ActiveRecord::Migration[5.1]
  def change
    create_table :occupations do |t|
      t.string :name
      t.string :ancestry

      t.belongs_to :language, foreign_key: true

      t.timestamps
    end

    create_table :occupation_translations do |t|
      t.string :name
      t.belongs_to :occupation, foreign_key: true
      t.belongs_to :language, foreign_key: true
      t.string :locale

      t.timestamps
    end

    add_index :occupations, :ancestry
  end
end
