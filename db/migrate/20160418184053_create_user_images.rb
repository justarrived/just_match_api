# frozen_string_literal: true

class CreateUserImages < ActiveRecord::Migration[4.2]
  def change
    create_table :user_images do |t|
      t.datetime :one_time_token_expires_at
      t.string :one_time_token
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_attachment :user_images, :image
  end
end
