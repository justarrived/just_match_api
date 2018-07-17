# frozen_string_literal: true

class RemoveFeedbacks < ActiveRecord::Migration[5.2]
  def up
    drop_table :feedbacks
  end
end
