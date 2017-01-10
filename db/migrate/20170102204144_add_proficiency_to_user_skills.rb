# frozen_string_literal: true
class AddProficiencyToUserSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :user_skills, :proficiency, :integer
    add_column :user_skills, :proficiency_by_admin, :integer
  end
end
