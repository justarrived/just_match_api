# frozen_string_literal: true

class AddCompetenceTextToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :competence_text, :text
  end
end
