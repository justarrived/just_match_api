# frozen_string_literal: true

class AddAdditionalDescriptionFieldsToJobs < ActiveRecord::Migration[5.1]
  def change
    # Job table
    add_column :jobs, :tasks_description, :text
    add_column :jobs, :applicant_description, :text
    add_column :jobs, :requirements_description, :text
    # JobTranslation table
    add_column :job_translations, :tasks_description, :text
    add_column :job_translations, :applicant_description, :text
    add_column :job_translations, :requirements_description, :text
  end
end
