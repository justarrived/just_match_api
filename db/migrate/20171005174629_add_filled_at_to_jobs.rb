# frozen_string_literal: true

class AddFilledAtToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :filled_at, :datetime
  end
end
