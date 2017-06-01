# frozen_string_literal: true

class AddHighPriorityToSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :skills, :high_priority, :boolean, default: false
  end
end
