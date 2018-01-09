# frozen_string_literal: true

class AddAttachmentImageToGuideImages < ActiveRecord::Migration[5.1]
  def self.up
    change_table :guide_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :guide_images, :image
  end
end
