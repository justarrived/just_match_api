# frozen_string_literal: true

class AddLangcodeToResourcesWithText < ActiveRecord::Migration[4.2]
  def change
    # Add language reference to models with text content
    add_reference :comments, :language, index: true, foreign_key: true
    add_reference :jobs,     :language, index: true, foreign_key: true
    add_reference :skills,   :language, index: true, foreign_key: true
    add_reference :users,    :language, index: true, foreign_key: true
  end
end
