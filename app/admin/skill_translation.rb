# frozen_string_literal: true
ActiveAdmin.register SkillTranslation do
  menu parent: 'Misc'

  permit_params do
    [:name, :locale, :language_id]
  end
end
