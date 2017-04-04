# frozen_string_literal: true
class AddProficiencyToJobSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :job_skills, :proficiency, :integer
  end
end
