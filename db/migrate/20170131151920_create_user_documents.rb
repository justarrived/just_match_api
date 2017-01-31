# frozen_string_literal: true
class CreateUserDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :user_documents do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :document, foreign_key: true
      t.integer :category

      t.timestamps
    end
  end
end
