# frozen_string_literal: true

class CreateCompanyImages < ActiveRecord::Migration
  def change
    create_table :company_images do |t|
      t.datetime :one_time_token_expires_at
      t.string :one_time_token
      t.belongs_to :company, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_attachment :company_images, :image
  end
end
