# frozen_string_literal: true
class AddJobExperienceAndEducationFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job_experience, :text
    add_column :users, :education, :text
  end
end
