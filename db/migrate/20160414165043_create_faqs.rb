# frozen_string_literal: true
class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.text :answer
      t.text :question
      t.belongs_to :language, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
