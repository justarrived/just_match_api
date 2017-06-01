# frozen_string_literal: true

class AddProficiencyByAdminToJobSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :job_skills, :proficiency_by_admin, :integer
  end
end
