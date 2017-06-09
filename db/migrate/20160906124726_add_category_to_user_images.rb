# frozen_string_literal: true

class AddCategoryToUserImages < ActiveRecord::Migration[4.2]
  def change
    add_column :user_images, :category, :integer
  end
end
