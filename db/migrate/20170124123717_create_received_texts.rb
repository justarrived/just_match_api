class CreateReceivedTexts < ActiveRecord::Migration[5.0]
  def change
    create_table :received_texts do |t|
      t.string :from_number
      t.string :to_number
      t.string :body

      t.timestamps
    end
  end
end
