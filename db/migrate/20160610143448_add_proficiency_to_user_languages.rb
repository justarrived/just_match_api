# frozen_string_literal: true

class AddProficiencyToUserLanguages < ActiveRecord::Migration
  def change
    add_column :user_languages, :proficiency, :integer
  end
end
