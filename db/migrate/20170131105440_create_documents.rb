# frozen_string_literal: true
class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.integer :category
      t.string :one_time_token
      t.datetime :one_time_token_expires_at

      t.timestamps
    end

    add_attachment :documents, :document
  end
end
