# frozen_string_literal: true

class EnableUnaccentPgExtension < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'unaccent'    
  end
end
