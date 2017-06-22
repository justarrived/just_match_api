# frozen_string_literal: true

class CreateIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :industries do |t|
      t.string :name
      t.string :ancestry

      t.belongs_to :language, foreign_key: true

      t.timestamps
    end

    add_index :industries, :ancestry
  end
end
