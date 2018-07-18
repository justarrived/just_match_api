# frozen_string_literal: true

class AddPublishedOnArbetsformedlingenToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :published_on_arbetsformedlingen_at, :datetime
  end
end
