# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :description

      t.timestamps null: false
    end
  end
end
