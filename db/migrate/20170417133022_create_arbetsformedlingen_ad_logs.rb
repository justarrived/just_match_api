# frozen_string_literal: true

class CreateArbetsformedlingenAdLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :arbetsformedlingen_ad_logs do |t|
      t.belongs_to :arbetsformedlingen_ad, foreign_key: true
      t.json :response

      t.timestamps
    end
  end
end
