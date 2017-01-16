# frozen_string_literal: true
class CreateCommunicationTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :communication_templates do |t|
      t.belongs_to :language, foreign_key: true
      t.string :category
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
