# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :job, foreign_key: true
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
