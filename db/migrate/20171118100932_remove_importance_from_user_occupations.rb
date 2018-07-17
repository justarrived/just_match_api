# frozen_string_literal: true

class RemoveImportanceFromUserOccupations < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_occupations, :importance, :integer
  end
end
