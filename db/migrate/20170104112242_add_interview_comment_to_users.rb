# frozen_string_literal: true

class AddInterviewCommentToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :interview_comment, :text
  end
end
