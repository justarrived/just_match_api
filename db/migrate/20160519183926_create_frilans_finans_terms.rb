# frozen_string_literal: true
class CreateFrilansFinansTerms < ActiveRecord::Migration
  def change
    create_table :frilans_finans_terms do |t|
      t.text :body
      t.boolean :company, default: false

      t.timestamps null: false
    end
  end
end
