# frozen_string_literal: true

class CreateMessageTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :message_translations do |t|
      t.string :locale
      t.text :body
      t.belongs_to :message, foreign_key: true

      t.timestamps
    end
  end
end
