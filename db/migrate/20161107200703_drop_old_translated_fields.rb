# frozen_string_literal: true
class DropOldTranslatedFields < ActiveRecord::Migration[5.0]
  def up
    remove_column :messages, :body

    remove_column :comments, :body

    remove_column :job_users, :apply_message

    remove_column :jobs, :name
    remove_column :jobs, :description
    remove_column :jobs, :short_description

    remove_column :users, :description
    remove_column :users, :job_experience
    remove_column :users, :education
    remove_column :users, :competence_text
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
