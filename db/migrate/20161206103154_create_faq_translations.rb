# frozen_string_literal: true
class CreateFaqTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :faq_translations do |t|
      t.string :locale
      t.text :question
      t.text :answer
      t.belongs_to :language, foreign_key: true
      t.belongs_to :faq, foreign_key: true

      t.timestamps
    end
  end
end
