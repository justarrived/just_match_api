# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration[4.2]
  def change
    create_table :currencies do |t|
      t.string :currency_code
      t.integer :frilans_finans_id

      t.timestamps null: false
    end
  end
end
