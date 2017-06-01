# frozen_string_literal: true

class AddMissingUniqIndexes < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true
    add_index :users, :auth_token, unique: true

    add_index :skills, :name, unique: true

    add_index :languages, :lang_code, unique: true

    add_index :chat_users, %i(chat_id user_id), unique: true
    add_index :chat_users, %i(user_id chat_id), unique: true

    add_index :job_skills, %i(skill_id job_id), unique: true
    add_index :job_skills, %i(job_id skill_id), unique: true

    add_index :job_users, %i(user_id job_id), unique: true
    add_index :job_users, %i(job_id user_id), unique: true

    add_index :user_languages, %i(user_id language_id), unique: true
    add_index :user_languages, %i(language_id user_id), unique: true

    add_index :user_skills, %i(skill_id user_id), unique: true
    add_index :user_skills, %i(user_id skill_id), unique: true
  end
end
