# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[4.2]
  def change
    create_table :invoices do |t|
      t.integer :frilans_finans_id
      t.belongs_to :job_user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :invoices, :frilans_finans_id, unique: true
  end
end
