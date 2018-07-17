# frozen_string_literal: true

class CreateUserOccupations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_occupations do |t|
      t.belongs_to :occupation, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :years_of_experience
      t.integer :importance

      t.timestamps
    end
  end
end
