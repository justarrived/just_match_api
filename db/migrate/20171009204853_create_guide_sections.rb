# frozen_string_literal: true

class CreateGuideSections < ActiveRecord::Migration[5.1]
  def change
    create_table :guide_sections do |t|
      t.integer :order
      t.belongs_to :language, foreign_key: true

      t.timestamps
    end
  end
end
