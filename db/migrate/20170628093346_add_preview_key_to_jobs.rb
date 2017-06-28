# frozen_string_literal: true

class AddPreviewKeyToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :preview_key, :string
  end
end
