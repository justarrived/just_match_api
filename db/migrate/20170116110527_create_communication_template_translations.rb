# frozen_string_literal: true
class CreateCommunicationTemplateTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :communication_template_translations do |t|
      t.string :subject
      t.text :body
      t.belongs_to :language, foreign_key: true
      t.string :locale
      t.integer :communication_template_id

      t.timestamps
    end
    add_index :communication_template_translations, :communication_template_id, name: 'index_comm_template_translations_on_comm_template_id' # rubocop:disable Metrics/LineLength
  end
end
