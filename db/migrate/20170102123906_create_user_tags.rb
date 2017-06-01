# frozen_string_literal: true

class CreateUserTags < ActiveRecord::Migration[5.0]
  def change
    create_table :user_tags do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end
  end
end
