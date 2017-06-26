# frozen_string_literal: true

class AddTextContentToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :text_content, :text
  end
end
