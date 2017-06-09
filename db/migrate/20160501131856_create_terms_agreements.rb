# frozen_string_literal: true

class CreateTermsAgreements < ActiveRecord::Migration[4.2]
  def change
    create_table :terms_agreements do |t|
      t.string :version, unique: true
      t.string :url, limit: 2000

      t.timestamps null: false
    end
  end
end
