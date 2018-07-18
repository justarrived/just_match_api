# frozen_string_literal: true

class RemoveInterviewCommentFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :interview_comment, :text
  end
end
