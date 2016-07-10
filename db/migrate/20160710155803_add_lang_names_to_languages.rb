# frozen_string_literal: true
class AddLangNamesToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :sv_name, :string
    add_column :languages, :ar_name, :string
    add_column :languages, :fa_name, :string
    add_column :languages, :fa_af_name, :string
    add_column :languages, :ku_name, :string
    add_column :languages, :ti_name, :string
    add_column :languages, :ps_name, :string
  end
end
