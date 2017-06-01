# frozen_string_literal: true

class CreateSkillFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :skill_filters do |t|
      t.belongs_to :filter, foreign_key: true
      t.integer :skill_id
      t.integer :proficiency
      t.integer :proficiency_by_admin

      t.timestamps
    end
    add_index :skill_filters, :skill_id
  end
end
