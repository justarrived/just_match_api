class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :lang_code
      t.boolean :primary, default: false

      t.timestamps null: false
    end
  end
end
