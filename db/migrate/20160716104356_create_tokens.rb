# frozen_string_literal: true
class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :token, index: true, unique: true
      t.datetime :expires_at

      t.timestamps null: false
    end
  end
end
