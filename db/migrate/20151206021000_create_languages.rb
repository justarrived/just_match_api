# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :languages do |t|
      t.string :lang_code

      t.timestamps null: false
    end
  end
end
