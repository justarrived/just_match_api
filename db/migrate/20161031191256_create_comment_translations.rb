# frozen_string_literal: true
class CreateCommentTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :comment_translations do |t|
      t.string :locale
      t.text :body
      t.belongs_to :comment, foreign_key: true

      t.timestamps
    end
  end
end
