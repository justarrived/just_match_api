# frozen_string_literal: true

class CreateArbetsformedlingenAds < ActiveRecord::Migration[5.0]
  def change
    create_table :arbetsformedlingen_ads do |t|
      t.belongs_to :job, foreign_key: true
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
