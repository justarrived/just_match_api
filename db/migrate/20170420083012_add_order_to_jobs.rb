# frozen_string_literal: true

class AddOrderToJobs < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :order, foreign_key: true
  end
end
