# frozen_string_literal: true
class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :chat, index: true, foreign_key: true
      t.integer :author_id, :integer
      t.belongs_to :language, index: true, foreign_key: true
      t.text :body

      t.timestamps null: false
    end
  end
end
