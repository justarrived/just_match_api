# frozen_string_literal: true

class AddOccupationToArbetsformedlingenAd < ActiveRecord::Migration[5.1]
  def change
    add_column :arbetsformedlingen_ads, :occupation, :string
  end
end
