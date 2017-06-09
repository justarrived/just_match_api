# frozen_string_literal: true

class AddProficiencyToUserLanguages < ActiveRecord::Migration[4.2]
  def change
    add_column :user_languages, :proficiency, :integer
  end
end
