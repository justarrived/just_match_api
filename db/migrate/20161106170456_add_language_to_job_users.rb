# frozen_string_literal: true
class AddLanguageToJobUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :job_users, :language, foreign_key: true
  end
end
