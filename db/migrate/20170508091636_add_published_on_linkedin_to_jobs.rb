# frozen_string_literal: true

class AddPublishedOnLinkedinToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :publish_on_linkedin, :boolean, default: false
  end
end
