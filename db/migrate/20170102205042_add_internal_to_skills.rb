# frozen_string_literal: true
class AddInternalToSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :skills, :internal, :boolean, default: false
  end
end
