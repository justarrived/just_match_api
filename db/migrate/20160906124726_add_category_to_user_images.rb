# frozen_string_literal: true
class AddCategoryToUserImages < ActiveRecord::Migration
  def change
    add_column :user_images, :category, :integer
  end
end
