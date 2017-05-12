# frozen_string_literal: true

class AddPublishOnBlocketjobbToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :publish_on_blocketjobb, :boolean, default: false
  end
end
