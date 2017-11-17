# frozen_string_literal: true

class CreateUtalkCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :utalk_codes do |t|
      t.string :code
      t.belongs_to :user, foreign_key: true
      t.datetime :claimed_at

      t.timestamps
    end
  end
end
