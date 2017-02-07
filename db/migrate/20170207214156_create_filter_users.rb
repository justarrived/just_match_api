# frozen_string_literal: true
class CreateFilterUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :filter_users do |t|
      t.belongs_to :filter, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
