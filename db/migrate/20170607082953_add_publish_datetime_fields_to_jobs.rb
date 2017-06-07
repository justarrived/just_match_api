# frozen_string_literal: true

class AddPublishDatetimeFieldsToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :publish_at, :datetime
    add_column :jobs, :unpublish_at, :datetime
  end
end
