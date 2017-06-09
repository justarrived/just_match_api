# frozen_string_literal: true

class CreateHourlyPays < ActiveRecord::Migration[4.2]
  def change
    create_table :hourly_pays do |t|
      t.boolean :active, default: false
      t.integer :rate
      t.string :currency, default: 'SEK'

      t.timestamps null: false
    end
  end
end
