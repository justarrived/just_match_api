# frozen_string_literal: true
class AddMissingUniqIndexes < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true
    add_index :users, :auth_token, unique: true

    add_index :skills, :name, unique: true

    add_index :languages, :lang_code, unique: true

    add_index :chat_users, [:chat_id, :user_id], unique: true
    add_index :chat_users, [:user_id, :chat_id], unique: true

    add_index :job_skills, [:skill_id, :job_id], unique: true
    add_index :job_skills, [:job_id, :skill_id], unique: true

    add_index :job_users, [:user_id, :job_id], unique: true
    add_index :job_users, [:job_id, :user_id], unique: true

    add_index :user_languages, [:user_id, :language_id], unique: true
    add_index :user_languages, [:language_id, :user_id], unique: true

    add_index :user_skills, [:skill_id, :user_id], unique: true
    add_index :user_skills, [:user_id, :skill_id], unique: true
  end
end
