# frozen_string_literal: true

class CreateGuideImages < ActiveRecord::Migration[5.1]
  def change
    create_table :guide_images do |t|
      t.string :title

      t.timestamps
    end
  end
end
