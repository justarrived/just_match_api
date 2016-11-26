# frozen_string_literal: true
ActiveAdmin.register Language do
  scope :all
  scope :system_languages, default: true
  scope :non_system_languages
  scope :rtl_languages
  scope :ltr_languages
  scope :machine_translation_languages

  filter :system_language
  filter :machine_translation
  filter :direction
  filter :local_name
  filter :en_name
  filter :sv_name
  filter :ar_name
  filter :fa_name
  filter :fa_af_name
  filter :ku_name
  filter :ti_name
  filter :ps_name

  index do
    column :id
    column :lang_code
    column :en_name
    column :direction
    column :system_language
    column :machine_translation_languages

    actions
  end

  permit_params do
    [
      :system_language, :machine_translation, :direction, :local_name, :en_name,
      :sv_name, :ar_name, :fa_name, :fa_af_name, :ku_name, :ti_name, :ps_name
    ]
  end
end
