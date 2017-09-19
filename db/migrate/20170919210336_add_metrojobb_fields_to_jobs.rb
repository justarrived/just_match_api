# frozen_string_literal: true

class AddMetrojobbFieldsToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :publish_on_metrojobb, :boolean, default: false
    add_column :jobs, :metrojobb_category, :string
  end
end
