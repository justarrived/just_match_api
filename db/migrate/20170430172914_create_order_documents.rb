# frozen_string_literal: true

class CreateOrderDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :order_documents do |t|
      t.string :name
      t.belongs_to :document, foreign_key: true
      t.belongs_to :order, foreign_key: true

      t.timestamps
    end
  end
end
